import 'package:flutter/material.dart';
import 'package:work_beacon/widgets/incident_card.dart';
import 'package:work_beacon/screens/admin/admin_view_incident.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminAllIncidentsScreen extends StatefulWidget {
  @override
  _AdminAllIncidentsScreenState createState() =>
      _AdminAllIncidentsScreenState();
}

class _AdminAllIncidentsScreenState extends State<AdminAllIncidentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesSearch(Map<String, dynamic> data, String documentId) {
    if (_searchKeyword.isEmpty) return true;

    final keyword = _searchKeyword.toLowerCase();

    // Search in title (category)
    final title = (data['category'] as String?) ?? '';
    if (title.toLowerCase().contains(keyword)) return true;

    // Search in description
    final description = (data['description'] as String?) ?? '';
    if (description.toLowerCase().contains(keyword)) return true;

    // Search in location
    final location = (data['location'] as String?) ?? '';
    if (location.toLowerCase().contains(keyword)) return true;

    // Search in status
    final status = (data['status'] as String?) ?? '';
    if (status.toLowerCase().contains(keyword)) return true;

    // Search in ID
    final id =
        'WB-${documentId.length >= 8 ? documentId.substring(0, 8).toUpperCase() : documentId.toUpperCase()}';
    if (id.toLowerCase().contains(keyword)) return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('All Incidents'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Container(
          color: const Color(0xFFF8FAFC),
          child: Center(child: Text('Please log in to view incidents')),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('All Incidents'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by keyword...',
                prefixIcon: Icon(Icons.search, color: const Color(0xFF61738D)),
                suffixIcon: _searchKeyword.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: const Color(0xFF61738D)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchKeyword = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFFF0F4F9),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFFF0F4F9),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFF2B7FFF),
                    width: 1.5,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value;
                });
              },
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF8FAFC),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('staff_incidents')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              String errorMessage = 'Error loading incidents';
              final error = snapshot.error.toString();

              if (error.contains('permission') ||
                  error.contains('PERMISSION_DENIED') ||
                  error.contains('Missing or insufficient permissions')) {
                errorMessage =
                    'Permission denied. Please check your Firestore security rules.';
              } else {
                errorMessage = 'Error loading incidents: ${snapshot.error}';
              }

              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text(
                        errorMessage,
                        style: TextStyle(
                          color: const Color(0xFF61738D),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No incidents found',
                  style: TextStyle(
                    color: const Color(0xFF61738D),
                    fontSize: 16,
                  ),
                ),
              );
            }

            // Sort incidents by createdAt in descending order (newest first)
            final allIncidents = snapshot.data!.docs.toList()
              ..sort((a, b) {
                final aData = a.data() as Map<String, dynamic>;
                final bData = b.data() as Map<String, dynamic>;
                final aTime = aData['createdAt'] as Timestamp?;
                final bTime = bData['createdAt'] as Timestamp?;

                if (aTime == null && bTime == null) return 0;
                if (aTime == null) return 1;
                if (bTime == null) return -1;

                return bTime.compareTo(aTime); // Descending order
              });

            // Filter incidents based on search keyword
            final filteredIncidents = allIncidents.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return _matchesSearch(data, doc.id);
            }).toList();

            if (filteredIncidents.isEmpty) {
              return Center(
                child: Text(
                  'No incidents match your search',
                  style: TextStyle(
                    color: const Color(0xFF61738D),
                    fontSize: 16,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: filteredIncidents.length,
              itemBuilder: (context, index) {
                final doc = filteredIncidents[index];
                final data = doc.data() as Map<String, dynamic>;

                // Format the date from createdAt timestamp
                String dateStr = 'N/A';
                if (data['createdAt'] != null) {
                  try {
                    final timestamp = data['createdAt'] as Timestamp;
                    final date = timestamp.toDate();
                    dateStr =
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  } catch (e) {
                    dateStr = 'N/A';
                  }
                }

                // Map status: 'pending' -> 'Open', handle other statuses
                String status = (data['status'] as String?) ?? 'Open';
                if (status.toLowerCase() == 'pending') {
                  status = 'Open';
                } else {
                  // Capitalize first letter of each word
                  status = status
                      .split(' ')
                      .map(
                        (word) => word.isEmpty
                            ? ''
                            : word[0].toUpperCase() +
                                  word.substring(1).toLowerCase(),
                      )
                      .join(' ');
                }

                // Get location or default (from location field)
                String location =
                    (data['location'] as String?) ?? 'Not specified';

                // Get category as title (from category field)
                String title = (data['category'] as String?) ?? 'Incident';

                // Get description (from description field)
                String description =
                    (data['description'] as String?) ?? 'No description';

                // Get photoUrl (from photoUrl field)
                String? photoUrl = data['photoUrl'] as String?;

                // Generate ID from document ID
                String id =
                    'WB-${doc.id.length >= 8 ? doc.id.substring(0, 8).toUpperCase() : doc.id.toUpperCase()}';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: IncidentCard(
                    title: title,
                    id: id,
                    status: status,
                    description: description,
                    location: location,
                    date: dateStr,
                    photoUrl: photoUrl,
                    documentId: doc.id,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminViewIncident(
                            title: title,
                            id: id,
                            status: status,
                            description: description,
                            location: location,
                            date: dateStr,
                            photoUrl: photoUrl,
                            documentId: doc.id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
