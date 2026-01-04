import 'package:flutter/material.dart';
import 'package:work_beacon/widgets/incident_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IncidentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Incidents'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Container(
          color: const Color(0xFFF8FAFC),
          child: Center(child: Text('Please log in to view your incidents')),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Incidents'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: const Color(0xFFF8FAFC),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('staff_incidents')
              .where('reportedBy', isEqualTo: user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error loading incidents: ${snapshot.error}'),
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
            final incidents = snapshot.data!.docs.toList()
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

            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                final doc = incidents[index];
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
