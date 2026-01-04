import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminViewIncident extends StatelessWidget {
  final String title;
  final String id;
  final String status;
  final String description;
  final String location;
  final String date;
  final String? photoUrl;
  final String documentId;

  const AdminViewIncident({
    Key? key,
    required this.title,
    required this.id,
    required this.status,
    required this.description,
    required this.location,
    required this.date,
    this.photoUrl,
    required this.documentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminIncidentDetails(
        title: title,
        id: id,
        status: status,
        description: description,
        location: location,
        date: date,
        photoUrl: photoUrl,
        documentId: documentId,
      ),
    );
  }
}

class AdminIncidentDetails extends StatefulWidget {
  final String title;
  final String id;
  final String status;
  final String description;
  final String location;
  final String date;
  final String? photoUrl;
  final String documentId;

  const AdminIncidentDetails({
    Key? key,
    required this.title,
    required this.id,
    required this.status,
    required this.description,
    required this.location,
    required this.date,
    this.photoUrl,
    required this.documentId,
  }) : super(key: key);

  @override
  State<AdminIncidentDetails> createState() => _AdminIncidentDetailsState();
}

class _AdminIncidentDetailsState extends State<AdminIncidentDetails> {
  bool _isUpdating = false;
  String _currentStatus = '';

  @override
  void initState() {
    super.initState();
    // Normalize status: 'pending' -> 'open', capitalize others
    String normalizedStatus = widget.status.toLowerCase();
    if (normalizedStatus == 'pending') {
      _currentStatus = 'open';
    } else {
      _currentStatus = normalizedStatus;
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Status'),
          content: Text(
            'Are you sure you want to update the status to "${newStatus.toUpperCase()}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2B7FFF),
              ),
              child: Text('Update'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      // Update status in Firestore
      // Map 'open' back to 'pending' if needed, or keep as is
      String statusToSave = newStatus.toLowerCase();
      if (statusToSave == 'open') {
        statusToSave = 'pending';
      }

      await FirebaseFirestore.instance
          .collection('staff_incidents')
          .doc(widget.documentId)
          .update({
            'status': statusToSave,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      if (mounted) {
        setState(() {
          _currentStatus = newStatus.toLowerCase();
          _isUpdating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating status: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final padding = isSmallScreen ? 16.0 : 24.0;

    // Get available status options based on current status
    List<String> availableStatuses = _getAvailableStatuses(_currentStatus);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: 16.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
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
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Incident Details',
                                style: TextStyle(
                                  color: const Color(0xFF0E162B),
                                  fontSize: isSmallScreen ? 18 : 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                  letterSpacing: -0.31,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                widget.id,
                                style: TextStyle(
                                  color: const Color(0xFF61738D),
                                  fontSize: isSmallScreen ? 13 : 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                  letterSpacing: -0.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildStatusBadge(_currentStatus, isSmallScreen),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            // Content Area
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Timeline Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Timeline',
                          style: TextStyle(
                            color: const Color(0xFF0E162B),
                            fontSize: isSmallScreen ? 16 : 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                            letterSpacing: -0.31,
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildStatusTimeline(
                          _currentStatus,
                          widget.date,
                          isSmallScreen,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  // Incident Information Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Incident Information',
                          style: TextStyle(
                            color: const Color(0xFF0E162B),
                            fontSize: isSmallScreen ? 16 : 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                            letterSpacing: -0.31,
                          ),
                        ),
                        SizedBox(height: 12),
                        // Category
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category',
                              style: TextStyle(
                                color: const Color(0xFF61738D),
                                fontSize: isSmallScreen ? 13 : 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                                letterSpacing: -0.15,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.title,
                              style: TextStyle(
                                color: const Color(0xFF0E162B),
                                fontSize: isSmallScreen ? 15 : 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                                letterSpacing: -0.31,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Divider(
                          height: 1,
                          thickness: 0.74,
                          color: const Color(0xFFF0F4F9),
                        ),
                        SizedBox(height: 12),
                        // Description
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                color: const Color(0xFF61738D),
                                fontSize: isSmallScreen ? 13 : 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                                letterSpacing: -0.15,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.description,
                              style: TextStyle(
                                color: const Color(0xFF0E162B),
                                fontSize: isSmallScreen ? 15 : 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.63,
                                letterSpacing: -0.31,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Divider(
                          height: 1,
                          thickness: 0.74,
                          color: const Color(0xFFF0F4F9),
                        ),
                        SizedBox(height: 12),
                        // Location
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: const Color(0xFF61738D),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Location',
                                  style: TextStyle(
                                    color: const Color(0xFF61738D),
                                    fontSize: isSmallScreen ? 13 : 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.43,
                                    letterSpacing: -0.15,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Padding(
                              padding: EdgeInsets.only(left: 24),
                              child: Text(
                                widget.location,
                                style: TextStyle(
                                  color: const Color(0xFF0E162B),
                                  fontSize: isSmallScreen ? 15 : 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                  letterSpacing: -0.31,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  // Attached Photo Card
                  if (widget.photoUrl != null)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.photo,
                                size: 16,
                                color: const Color(0xFF61738D),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Attached Photo',
                                style: TextStyle(
                                  color: const Color(0xFF61738D),
                                  fontSize: isSmallScreen ? 13 : 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                  letterSpacing: -0.15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              minHeight: 200,
                              maxHeight: isSmallScreen ? 250 : 300,
                            ),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF8FAFC),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.74,
                                  color: const Color(0xFFE1E8F0),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: widget.photoUrl!.isNotEmpty
                                ? Image.network(
                                    widget.photoUrl!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 64,
                                          color: const Color(0xFFE1E8F0),
                                        ),
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 64,
                                      color: const Color(0xFFE1E8F0),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.photoUrl != null) SizedBox(height: 16),
                  // Update Status Card
                  if (availableStatuses.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Update Status',
                            style: TextStyle(
                              color: const Color(0xFF0E162B),
                              fontSize: isSmallScreen ? 16 : 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                              letterSpacing: -0.31,
                            ),
                          ),
                          SizedBox(height: 12),
                          ...availableStatuses.map((status) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isUpdating
                                      ? null
                                      : () => _updateStatus(status),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _getStatusButtonColor(
                                      status,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isUpdating
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              _getStatusIcon(status),
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Mark as ${status.toUpperCase()}',
                                              style: TextStyle(
                                                fontSize: isSmallScreen
                                                    ? 14
                                                    : 15,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            );
                          }),
                        ],
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

  List<String> _getAvailableStatuses(String currentStatus) {
    final statusLower = currentStatus.toLowerCase();

    if (statusLower == 'open' || statusLower == 'pending') {
      return ['in progress', 'resolved'];
    } else if (statusLower == 'in progress') {
      return ['resolved'];
    } else {
      // Resolved - no further updates
      return [];
    }
  }

  Color _getStatusButtonColor(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return const Color(0xFF2B7FFF);
      case 'resolved':
        return const Color(0xFF00C850);
      default:
        return const Color(0xFF2B7FFF);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return Icons.work_outline;
      case 'resolved':
        return Icons.check_circle_outline;
      default:
        return Icons.update;
    }
  }

  Widget _buildStatusBadge(String status, bool isSmallScreen) {
    Color badgeColor;
    Color borderColor;
    Color dotColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'open':
      case 'pending':
        badgeColor = const Color(0xFFFFECD4);
        borderColor = const Color(0xFFFFD6A7);
        dotColor = const Color(0xFFC93400);
        textColor = const Color(0xFFC93400);
        break;
      case 'in progress':
        badgeColor = const Color(0xFFE3F2FD);
        borderColor = const Color(0xFFBBDEFB);
        dotColor = const Color(0xFF2B7FFF);
        textColor = const Color(0xFF2B7FFF);
        break;
      case 'resolved':
        badgeColor = const Color(0xFFE8F5E9);
        borderColor = const Color(0xFFC8E6C9);
        dotColor = const Color(0xFF00C850);
        textColor = const Color(0xFF00C850);
        break;
      default:
        badgeColor = const Color(0xFFFFECD4);
        borderColor = const Color(0xFFFFD6A7);
        dotColor = const Color(0xFFC93400);
        textColor = const Color(0xFFC93400);
    }

    // Display text
    String displayStatus = status.toLowerCase();
    if (displayStatus == 'pending') {
      displayStatus = 'open';
    }
    displayStatus = displayStatus
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: ShapeDecoration(
        color: badgeColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.74, color: borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          SizedBox(width: 6),
          Text(
            displayStatus,
            style: TextStyle(
              color: textColor,
              fontSize: isSmallScreen ? 11 : 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(String status, String date, bool isSmallScreen) {
    final statusLower = status.toLowerCase();
    final isResolved = statusLower == 'resolved';
    final isInProgress =
        statusLower == 'in progress' || statusLower == 'in_progress';
    final isOpen = statusLower == 'open' || statusLower == 'pending';

    return Column(
      children: [
        if (isResolved) ...[
          _buildTimelineItem(
            color: const Color(0xFF00C850),
            title: 'Resolved',
            isActive: true,
            date: '$date at 09:15 AM',
            isSmallScreen: isSmallScreen,
          ),
          SizedBox(height: 12),
        ],
        if (isInProgress || isResolved) ...[
          _buildTimelineItem(
            color: const Color(0xFF2B7FFF),
            title: 'In Progress',
            isActive: isInProgress,
            date: isInProgress ? '$date at 09:15 AM' : null,
            isSmallScreen: isSmallScreen,
          ),
          SizedBox(height: 12),
        ],
        _buildTimelineItem(
          color: const Color(0xFFFFECD4),
          title: 'Reported',
          isActive: isOpen,
          date: isOpen ? '$date at 09:15 AM' : null,
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required Color color,
    required String title,
    bool isActive = false,
    String? date,
    required bool isSmallScreen,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: isSmallScreen ? 28 : 32,
          height: isSmallScreen ? 28 : 32,
          decoration: ShapeDecoration(
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Icon(
            Icons.check,
            size: isSmallScreen ? 14 : 16,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isActive
                      ? const Color(0xFF0E162B)
                      : const Color(0xFF90A1B8),
                  fontSize: isSmallScreen ? 13 : 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                  letterSpacing: -0.15,
                ),
              ),
              if (date != null) ...[
                SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    color: const Color(0xFF61738D),
                    fontSize: isSmallScreen ? 11 : 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
