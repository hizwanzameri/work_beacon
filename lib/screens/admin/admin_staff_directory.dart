import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_beacon/services/profile_service.dart';

class AdminStaffDirectory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Staff Directory',
          style: TextStyle(
            color: const Color(0xFF0E162B),
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.50,
            letterSpacing: 0.07,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Color(0x19000000),
      ),
      body: Staffdirectoryscreen(),
    );
  }
}

class Staffdirectoryscreen extends StatefulWidget {
  @override
  State<Staffdirectoryscreen> createState() => _StaffdirectoryscreenState();
}

class _StaffdirectoryscreenState extends State<Staffdirectoryscreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _getStatus(Map<String, dynamic> profile) {
    // You can customize this logic based on your status field
    // For now, we'll use a default status or check if there's a status field
    return profile['status'] ?? 'Active';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF008236);
      case 'pending':
        return const Color(0xFFA65F00);
      case 'inactive':
        return const Color(0xFF314157);
      default:
        return const Color(0xFF008236);
    }
  }

  List<DocumentSnapshot> _filterStaff(List<DocumentSnapshot> staffList) {
    var filtered = staffList;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) return false;
        final name = (data['fullName'] ?? '').toString().toLowerCase();
        final email = (data['email'] ?? '').toString().toLowerCase();
        final staffId = (data['staffId'] ?? '').toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) ||
            email.contains(query) ||
            staffId.contains(query);
      }).toList();
    }

    // Apply status filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) return false;
        final status = _getStatus(data);
        return status.toLowerCase() == _selectedFilter.toLowerCase();
      }).toList();
    }

    return filtered;
  }

  Map<String, int> _getStatusCounts(List<DocumentSnapshot> staffList) {
    final counts = <String, int>{
      'All': staffList.length,
      'Active': 0,
      'Pending': 0,
      'Inactive': 0,
    };

    for (var doc in staffList) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        final status = _getStatus(data);
        counts[status] = (counts[status] ?? 0) + 1;
      }
    }

    return counts;
  }

  Widget _buildStaffCard(Map<String, dynamic> profile, String staffId) {
    final initials = _getInitials(profile['fullName'] ?? '');
    final status = _getStatus(profile);
    final statusColor = _getStatusColor(status);
    final fullName = profile['fullName'] ?? 'No Name';
    final staffIdText = profile['staffId'] ?? '';
    final department = profile['department'] ?? '';
    final email = profile['email'] ?? '';

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AdminStaffProfileView(staffId: staffId),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.74, color: const Color(0xFFF0F4F9)),
            borderRadius: BorderRadius.circular(14),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: -1,
            ),
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 3,
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, 0.00),
                  end: Alignment(1.00, 1.00),
                  colors: [const Color(0xFF2B7FFF), const Color(0xFF155CFB)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24675400),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                      letterSpacing: -0.31,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          fullName,
                          style: TextStyle(
                            color: const Color(0xFF0E162B),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                            letterSpacing: -0.31,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.verified,
                        size: 16,
                        color: const Color(0xFF155DFC),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      staffIdText.isNotEmpty && department.isNotEmpty
                          ? '$staffIdText • $department'
                          : staffIdText.isNotEmpty
                          ? staffIdText
                          : department.isNotEmpty
                          ? department
                          : 'No Department',
                      style: TextStyle(
                        color: const Color(0xFF61738D),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      email,
                      style: TextStyle(
                        color: const Color(0xFF90A1B8),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final padding = isMobile ? 16.0 : 24.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 44,
                  right: 16,
                  bottom: 12,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF8FAFC),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.74,
                      color: const Color(0xFFE1E8F0),
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      color: const Color(0xFF90A1B8),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search staff...',
                          hintStyle: TextStyle(
                            color: const Color(0xFF90A1B8),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.31,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          color: const Color(0xFF0E162B),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.31,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Filter Buttons - Using Wrap for responsiveness
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('staff_profiles')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _FilterButton(
                          text: 'All (0)',
                          isSelected: _selectedFilter == 'All',
                          isMobile: isMobile,
                          onTap: () => setState(() => _selectedFilter = 'All'),
                        ),
                      ],
                    );
                  }

                  final staffList = snapshot.data!.docs;
                  final statusCounts = _getStatusCounts(staffList);

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterButton(
                        text: 'All (${statusCounts['All'] ?? 0})',
                        isSelected: _selectedFilter == 'All',
                        isMobile: isMobile,
                        onTap: () => setState(() => _selectedFilter = 'All'),
                      ),
                      _FilterButton(
                        text: 'Active (${statusCounts['Active'] ?? 0})',
                        isSelected: _selectedFilter == 'Active',
                        isMobile: isMobile,
                        onTap: () => setState(() => _selectedFilter = 'Active'),
                      ),
                      _FilterButton(
                        text: 'Pending (${statusCounts['Pending'] ?? 0})',
                        isSelected: _selectedFilter == 'Pending',
                        isMobile: isMobile,
                        onTap: () =>
                            setState(() => _selectedFilter = 'Pending'),
                      ),
                      _FilterButton(
                        text: 'Inactive (${statusCounts['Inactive'] ?? 0})',
                        isSelected: _selectedFilter == 'Inactive',
                        isMobile: isMobile,
                        onTap: () =>
                            setState(() => _selectedFilter = 'Inactive'),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16),
              // Staff List
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('staff_profiles')
                    .orderBy('fullName')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'Error loading staff: ${snapshot.error}',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'No staff members found',
                          style: TextStyle(
                            color: const Color(0xFF61738D),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }

                  final allStaff = snapshot.data!.docs;
                  final filteredStaff = _filterStaff(allStaff);

                  if (filteredStaff.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'No staff members match your search',
                          style: TextStyle(
                            color: const Color(0xFF61738D),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var doc in filteredStaff)
                        Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: _buildStaffCard(
                            doc.data() as Map<String, dynamic>,
                            doc.id,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Admin Staff Profile View
class AdminStaffProfileView extends StatefulWidget {
  final String staffId;

  const AdminStaffProfileView({required this.staffId});

  @override
  State<AdminStaffProfileView> createState() => _AdminStaffProfileViewState();
}

class _AdminStaffProfileViewState extends State<AdminStaffProfileView> {
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  String _initials = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final profileData = await ProfileService.getUserProfile(widget.staffId);
      if (profileData != null && mounted) {
        setState(() {
          _profileData = profileData;
          _initials = _getInitials(profileData['fullName'] ?? '');
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: ${e.toString()}')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    try {
      if (timestamp is Timestamp) {
        final date = timestamp.toDate();
        final months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
        return '${months[date.month - 1]} ${date.day}, ${date.year}';
      }
      return 'N/A';
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;
    final padding = isSmallScreen ? 16.0 : 24.0;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Staff Profile'),
          backgroundColor: Colors.white,
        ),
        body: Container(
          width: double.infinity,
          height: screenHeight,
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC)),
          child: SafeArea(child: Center(child: CircularProgressIndicator())),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Staff Profile',
          style: TextStyle(
            color: const Color(0xFF0E162B),
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.50,
            letterSpacing: 0.07,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Color(0x19000000),
      ),
      body: Container(
        width: double.infinity,
        height: screenHeight,
        decoration: BoxDecoration(color: const Color(0xFFF8FAFC)),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(padding),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.74,
                        color: const Color(0xFFF0F4F9),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                        spreadRadius: -1,
                      ),
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: isSmallScreen ? 80 : 96,
                        height: isSmallScreen ? 80 : 96,
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.00, 0.00),
                            end: Alignment(1.00, 1.00),
                            colors: [
                              const Color(0xFF2B7FFF),
                              const Color(0xFF155CFB),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 3.68,
                              color: const Color(0xFFDAEAFE),
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _initials,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 20 : 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.33,
                              letterSpacing: 0.07,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        _profileData?['fullName'] ?? 'No Name',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF0E162B),
                          fontSize: isSmallScreen ? 14 : 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: -0.31,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _profileData?['position'] ?? 'No Position',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF61738D),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                          letterSpacing: -0.15,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Staff ID: ${_profileData?['staffId'] ?? 'N/A'}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF90A1B8),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(padding),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.74,
                        color: const Color(0xFFF0F4F9),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                        spreadRadius: -1,
                      ),
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Information',
                        style: TextStyle(
                          color: const Color(0xFF0E162B),
                          fontSize: isSmallScreen ? 14 : 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: -0.31,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.person_outline,
                        label: 'Full Name',
                        value: _profileData?['fullName'] ?? 'N/A',
                      ),
                      SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: _profileData?['email'] ?? 'N/A',
                      ),
                      SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: _profileData?['phone']?.isNotEmpty == true
                            ? _profileData!['phone']
                            : 'N/A',
                      ),
                      SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.business_outlined,
                        label: 'Department',
                        value: _profileData?['department']?.isNotEmpty == true
                            ? _profileData!['department']
                            : 'N/A',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(padding),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.74,
                        color: const Color(0xFFF0F4F9),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                        spreadRadius: -1,
                      ),
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Employment Details',
                        style: TextStyle(
                          color: const Color(0xFF0E162B),
                          fontSize: isSmallScreen ? 14 : 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: -0.31,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildDetailRow(
                        'Join Date',
                        _formatDate(_profileData?['joinDate']),
                      ),
                      SizedBox(height: 8),
                      _buildDetailRow(
                        'Position',
                        _profileData?['position']?.isNotEmpty == true
                            ? _profileData!['position']
                            : 'N/A',
                      ),
                      SizedBox(height: 8),
                      _buildDetailRow(
                        'Staff ID',
                        _profileData?['staffId']?.isNotEmpty == true
                            ? _profileData!['staffId']
                            : 'N/A',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: ShapeDecoration(
            color: const Color(0xFFDBEAFE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF155CFB)),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF61738D),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: const Color(0xFF0E162B),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                  letterSpacing: -0.15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xFF61738D),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
              letterSpacing: -0.15,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: const Color(0xFF0E162B),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
              letterSpacing: -0.15,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Filter Button Widget
class _FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isMobile;
  final VoidCallback? onTap;

  const _FilterButton({
    required this.text,
    required this.isSelected,
    required this.isMobile,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF155DFC) : const Color(0xFFF1F5F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF45556C),
            fontSize: isMobile ? 14 : 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
            letterSpacing: -0.31,
          ),
        ),
      ),
    );
  }
}
