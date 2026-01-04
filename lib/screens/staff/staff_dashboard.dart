import 'package:flutter/material.dart';
import 'staff_profile.dart';
import 'staff_report_incident.dart';
import 'incidents.dart';
import 'staff_alert_history.dart';

class StaffDashboard extends StatelessWidget {
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
                                      'Hi, Sarah Johnson',
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
                                        '1',
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
                                Column(
                                  children: [
                                    // Alert 1
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(13.47),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFFFECD4),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 1.47,
                                            color: const Color(0xFFFFD6A7),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: const Color(0xFFC93400),
                                            size: 16,
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Building Evacuation Required',
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFFC93400,
                                                    ),
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.43,
                                                    letterSpacing: -0.15,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Opacity(
                                                  opacity: 0.75,
                                                  child: Text(
                                                    'Due to a fire alarm activation in Building A, all staff must evacuate immediately. Please proceed to the designated assembly point in Parking Lot C.',
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFFC93400,
                                                      ),
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.33,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Opacity(
                                                  opacity: 0.60,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.access_time,
                                                        color: const Color(
                                                          0xFFC93400,
                                                        ),
                                                        size: 12,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        '5 min ago',
                                                        style: TextStyle(
                                                          color: const Color(
                                                            0xFFC93400,
                                                          ),
                                                          fontSize: 12,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.33,
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
                                    SizedBox(height: 8),
                                    // Alert 2
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(13.47),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFFEF9C2),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 1.47,
                                            color: const Color(0xFFFEEF85),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: const Color(0xFFA65F00),
                                            size: 16,
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Wet Floor - Warehouse Bay 7',
                                                        style: TextStyle(
                                                          color: const Color(
                                                            0xFFA65F00,
                                                          ),
                                                          fontSize: 14,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1.43,
                                                          letterSpacing: -0.15,
                                                        ),
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.close,
                                                      color: const Color(
                                                        0xFFA65F00,
                                                      ),
                                                      size: 16,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                                Opacity(
                                                  opacity: 0.75,
                                                  child: Text(
                                                    'Spilled liquid creating slip hazard near loading dock. Area has been cordoned off. Please use alternative routes.',
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFFA65F00,
                                                      ),
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.33,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Opacity(
                                                  opacity: 0.60,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.access_time,
                                                        color: const Color(
                                                          0xFFA65F00,
                                                        ),
                                                        size: 12,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        '1 hour ago',
                                                        style: TextStyle(
                                                          color: const Color(
                                                            0xFFA65F00,
                                                          ),
                                                          fontSize: 12,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.33,
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
                                  ],
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
