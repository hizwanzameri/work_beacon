import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffIncidentDetails extends StatelessWidget {
  final String title;
  final String id;
  final String status;
  final String description;
  final String location;
  final String date;
  final String? photoUrl;
  final String documentId;

  const StaffIncidentDetails({
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
      body: Myincidents(
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

class Myincidents extends StatefulWidget {
  final String title;
  final String id;
  final String status;
  final String description;
  final String location;
  final String date;
  final String? photoUrl;
  final String documentId;

  const Myincidents({
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
  State<Myincidents> createState() => _MyincidentsState();
}

class _MyincidentsState extends State<Myincidents> {
  bool _isDeleting = false;

  Future<void> _deleteIncident() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Incident'),
          content: Text(
            'Are you sure you want to delete this incident? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('staff_incidents')
          .doc(widget.documentId)
          .delete();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incident deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting incident: ${e.toString()}'),
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
    final canDelete =
        widget.status.toLowerCase() == 'open' ||
        widget.status.toLowerCase() == 'pending';

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
                        _buildStatusBadge(widget.status, isSmallScreen),
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
                          widget.status,
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
                  // Delete Button (only show when status is pending)
                  if (canDelete)
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
                            'Actions',
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
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isDeleting ? null : _deleteIncident,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: _isDeleting
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
                                        Icon(Icons.delete_outline, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          'Delete Incident',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 14 : 15,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
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

  Widget _buildStatusBadge(String status, bool isSmallScreen) {
    Color badgeColor;
    Color borderColor;
    Color dotColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'open':
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
            status,
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
    final isInProgress = statusLower == 'in progress';
    final isOpen = statusLower == 'open';

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
