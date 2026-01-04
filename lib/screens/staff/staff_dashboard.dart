import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:work_beacon/services/profile_service.dart';
import 'staff_profile.dart';
import 'staff_report_incident.dart';
import 'incidents.dart';
import 'staff_alert_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'staff_alert_details.dart';

class StaffDashboard extends StatefulWidget {
  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  bool _isLoading = true;
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final profileData = await ProfileService.getUserProfile(user.uid);
        if (profileData != null && mounted) {
          setState(() {
            _userName = profileData['fullName'] ?? user.displayName ?? 'User';
            _isLoading = false;
          });
        } else if (mounted) {
          setState(() {
            _userName = user.displayName ?? 'User';
            _isLoading = false;
          });
        }
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final padding = isSmallScreen ? 16.0 : 24.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC)),
                child: Column(
                  children: [
                    // Header Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + padding,
                        left: padding,
                        right: padding,
                        bottom: padding,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, 0.00),
                          end: Alignment(1.00, 1.00),
                          colors: [
                            const Color(0xFF155CFB),
                            const Color(0xFF1347E5),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome back,',
                                      style: TextStyle(
                                        color: const Color(0xFFDAEAFE),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.43,
                                        letterSpacing: -0.15,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _isLoading ? 'Loading...' : 'Hi, $_userName',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.33,
                                        letterSpacing: 0.07,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Icon(
                                        Icons.notifications_outlined,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    Positioned(
                                      left: 8,
                                      top: -4,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFFF6900),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              24675400,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '3',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 1.33,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          // Stats Cards
                          Row(
                            children: [
                              Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('alerts')
                                      .where('status', isEqualTo: 'active')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    int activeAlertsCount = 0;
                                    if (snapshot.hasData) {
                                      activeAlertsCount =
                                          snapshot.data!.docs.length;
                                    }

                                    return Container(
                                      padding: EdgeInsets.all(12.73),
                                      decoration: ShapeDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 0.74,
                                            color: const Color(0x33FFFEFE),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Active Alerts',
                                            style: TextStyle(
                                              color: const Color(0xFFDAEAFE),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 1.33,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '$activeAlertsCount',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 1.33,
                                              letterSpacing: 0.07,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(12.73),
                                  decoration: ShapeDecoration(
                                    color: Colors.white.withValues(alpha: 0.10),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 0.74,
                                        color: const Color(0x33FFFEFE),
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'My Reports',
                                        style: TextStyle(
                                          color: const Color(0xFFDAEAFE),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 1.33,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '3',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 1.33,
                                          letterSpacing: 0.07,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Content Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Latest Alerts Card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.73),
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
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                  spreadRadius: -4,
                                ),
                                BoxShadow(
                                  color: Color(0x19000000),
                                  blurRadius: 15,
                                  offset: Offset(0, 10),
                                  spreadRadius: -3,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Latest Alerts',
                                      style: TextStyle(
                                        color: const Color(0xFF0E162B),
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.50,
                                        letterSpacing: -0.31,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StaffAlertHistory(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'View All',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFF155CFB),
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 1.43,
                                          letterSpacing: -0.15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                // Alert Items
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('alerts')
                                      .where('status', isEqualTo: 'active')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      String errorMessage =
                                          'Error loading alerts';
                                      final error = snapshot.error.toString();

                                      if (error.contains('permission') ||
                                          error.contains('PERMISSION_DENIED') ||
                                          error.contains(
                                            'Missing or insufficient permissions',
                                          )) {
                                        errorMessage =
                                            'Permission denied. Please check your Firestore security rules.';
                                      } else if (error.contains('index')) {
                                        errorMessage =
                                            'Firestore index required. Please create the composite index.';
                                      } else {
                                        errorMessage =
                                            'Error loading alerts: ${snapshot.error}';
                                      }

                                      return Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                              size: 24,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              errorMessage,
                                              style: TextStyle(
                                                color: const Color(0xFF61738D),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'No active alerts',
                                          style: TextStyle(
                                            color: const Color(0xFF61738D),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    }

                                    // Sort alerts by createdAt descending and take the latest 2
                                    final allAlerts =
                                        snapshot.data!.docs.toList()..sort((
                                          a,
                                          b,
                                        ) {
                                          final aData =
                                              a.data() as Map<String, dynamic>;
                                          final bData =
                                              b.data() as Map<String, dynamic>;
                                          final aTime =
                                              aData['createdAt'] as Timestamp?;
                                          final bTime =
                                              bData['createdAt'] as Timestamp?;

                                          if (aTime == null && bTime == null)
                                            return 0;
                                          if (aTime == null) return 1;
                                          if (bTime == null) return -1;
                                          return bTime.compareTo(
                                            aTime,
                                          ); // Descending order
                                        });

                                    final alerts = allAlerts.take(2).toList();

                                    if (alerts.isEmpty) {
                                      return Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'No active alerts',
                                          style: TextStyle(
                                            color: const Color(0xFF61738D),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    }

                                    return Column(
                                      children: alerts.asMap().entries.map((
                                        entry,
                                      ) {
                                        final index = entry.key;
                                        final doc = entry.value;
                                        final data =
                                            doc.data() as Map<String, dynamic>;

                                        final alertType =
                                            (data['alertType'] as String?) ??
                                            'Info';
                                        final title =
                                            (data['title'] as String?) ??
                                            'No Title';
                                        final description =
                                            (data['description'] as String?) ??
                                            '';
                                        final timestamp =
                                            data['createdAt'] as Timestamp?;

                                        // Format relative time
                                        String timeText = 'Unknown time';
                                        if (timestamp != null) {
                                          final now = DateTime.now();
                                          final time = timestamp.toDate();
                                          final difference = now.difference(
                                            time,
                                          );

                                          if (difference.inMinutes < 1) {
                                            timeText = 'Just now';
                                          } else if (difference.inMinutes <
                                              60) {
                                            timeText =
                                                '${difference.inMinutes} min ago';
                                          } else if (difference.inHours < 24) {
                                            timeText =
                                                '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
                                          } else if (difference.inDays < 7) {
                                            timeText =
                                                '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
                                          } else {
                                            timeText =
                                                '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
                                          }
                                        }

                                        // Get colors based on alert type
                                        Color backgroundColor;
                                        Color borderColor;
                                        Color textColor;

                                        switch (alertType.toLowerCase()) {
                                          case 'emergency':
                                            backgroundColor = const Color(
                                              0xFFFFECD4,
                                            );
                                            borderColor = const Color(
                                              0xFFFFD6A7,
                                            );
                                            textColor = const Color(0xFFC93400);
                                            break;
                                          case 'safety':
                                            backgroundColor = const Color(
                                              0xFFFEF9C2,
                                            );
                                            borderColor = const Color(
                                              0xFFFEEF85,
                                            );
                                            textColor = const Color(0xFFA65F00);
                                            break;
                                          case 'info':
                                            backgroundColor = const Color(
                                              0xFFDBEAFE,
                                            );
                                            borderColor = const Color(
                                              0xFFBDDAFF,
                                            );
                                            textColor = const Color(0xFF1447E6);
                                            break;
                                          default:
                                            backgroundColor = const Color(
                                              0xFFDBEAFE,
                                            );
                                            borderColor = const Color(
                                              0xFFBDDAFF,
                                            );
                                            textColor = const Color(0xFF1447E6);
                                        }

                                        return Column(
                                          children: [
                                            if (index > 0) SizedBox(height: 8),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        StaffAlertDetails(
                                                          type: alertType,
                                                          title: title,
                                                          description:
                                                              description,
                                                          time: timeText,
                                                        ),
                                                  ),
                                                );
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(13.47),
                                                decoration: ShapeDecoration(
                                                  color: backgroundColor,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      width: 1.47,
                                                      color: borderColor,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                  ),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .warning_amber_rounded,
                                                      color: textColor,
                                                      size: 16,
                                                    ),
                                                    SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            title,
                                                            style: TextStyle(
                                                              color: textColor,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1.43,
                                                              letterSpacing:
                                                                  -0.15,
                                                            ),
                                                          ),
                                                          SizedBox(height: 4),
                                                          Opacity(
                                                            opacity: 0.75,
                                                            child: Text(
                                                              description.length >
                                                                      150
                                                                  ? '${description.substring(0, 150)}...'
                                                                  : description,
                                                              style: TextStyle(
                                                                color:
                                                                    textColor,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.33,
                                                              ),
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          SizedBox(height: 4),
                                                          Opacity(
                                                            opacity: 0.60,
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .access_time,
                                                                  color:
                                                                      textColor,
                                                                  size: 12,
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(
                                                                  timeText,
                                                                  style: TextStyle(
                                                                    color:
                                                                        textColor,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height:
                                                                        1.33,
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
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: padding),
                          // Quick Actions Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick Actions',
                                style: TextStyle(
                                  color: const Color(0xFF0E162B),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                  letterSpacing: -0.31,
                                ),
                              ),
                              SizedBox(height: 12),
                              // Report Incident Button
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StaffReportIncident(),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 12,
                                    ),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFF54900),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      shadows: [
                                        BoxShadow(
                                          color: Color(0x19000000),
                                          blurRadius: 6,
                                          offset: Offset(0, 4),
                                          spreadRadius: -4,
                                        ),
                                        BoxShadow(
                                          color: Color(0x19000000),
                                          blurRadius: 15,
                                          offset: Offset(0, 10),
                                          spreadRadius: -3,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_alert,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Report Incident',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 1.56,
                                            letterSpacing: -0.44,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              // Action Buttons Row
                              Row(
                                children: [
                                  Expanded(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  IncidentsScreen(),
                                            ),
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(14),
                                        child: Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1.47,
                                                color: const Color(0xFFE1E8F0),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.assignment,
                                                color: const Color(0xFF314157),
                                                size: 24,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'My Incidents',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFF314157,
                                                  ),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.43,
                                                  letterSpacing: -0.15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StaffProfile(),
                                            ),
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(14),
                                        child: Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1.47,
                                                color: const Color(0xFFE1E8F0),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.person_outline,
                                                color: const Color(0xFF314157),
                                                size: 24,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'Profile',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFF314157,
                                                  ),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.43,
                                                  letterSpacing: -0.15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
      ),
    );
  }
}
