import 'package:flutter/material.dart';
import 'package:work_beacon/screens/admin/admin_all_incidents.dart';
import 'package:work_beacon/screens/admin/admin_sendalertscreen.dart';
import 'package:work_beacon/screens/admin/admin_staff_directory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:work_beacon/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: App());
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final padding = isSmallScreen ? 12.0 : 16.0;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section (Navbar)
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + padding,
                left: padding,
                right: padding,
                bottom: padding,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            color: const Color(0xFF61738D),
                            fontSize: isSmallScreen ? 12 : 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.43,
                            letterSpacing: -0.15,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'WorkBeacon Admin Dashboard',
                          style: TextStyle(
                            color: const Color(0xFF0E162B),
                            fontSize: isSmallScreen ? 14 : 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                            letterSpacing: -0.31,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          Icon(
                            Icons.notifications_outlined,
                            size: 24,
                            color: const Color(0xFF61738D),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFFF6900),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '5',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          Icons.logout,
                          size: 24,
                          color: const Color(0xFF61738D),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error signing out: $e')),
                            );
                          }
                        },
                        tooltip: 'Logout',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Stats',
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
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('alerts')
                            .where('status', isEqualTo: 'active')
                            .snapshots(),
                        builder: (context, snapshot) {
                          int activeAlertsCount = 0;
                          if (snapshot.hasData) {
                            activeAlertsCount = snapshot.data!.docs.length;
                          }

                          return _buildStatCard(
                            context: context,
                            title: '$activeAlertsCount',
                            subtitle: 'Active Alerts',
                            gradient: LinearGradient(
                              begin: Alignment(0.00, 0.00),
                              end: Alignment(1.00, 1.00),
                              colors: [
                                const Color(0xFFFF6800),
                                const Color(0xFFF44900),
                              ],
                            ),
                            iconColor: const Color(0xFFFFECD4),
                            isSmallScreen: isSmallScreen,
                            icon: Icons.warning_amber_rounded,
                          );
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('staff_incidents')
                            .where('status', isEqualTo: 'pending')
                            .snapshots(),
                        builder: (context, snapshot) {
                          int openIncidentsCount = 0;
                          if (snapshot.hasData) {
                            openIncidentsCount = snapshot.data!.docs.length;
                          }

                          return _buildStatCard(
                            context: context,
                            title: '$openIncidentsCount',
                            subtitle: 'Open Incidents',
                            gradient: LinearGradient(
                              begin: Alignment(0.00, 0.00),
                              end: Alignment(1.00, 1.00),
                              colors: [
                                const Color(0xFF2B7FFF),
                                const Color(0xFF155CFB),
                              ],
                            ),
                            iconColor: const Color(0xFFDAEAFE),
                            isSmallScreen: isSmallScreen,
                            icon: Icons.report_problem_rounded,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFFEF9C2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Icon(
                                  Icons.access_time_rounded,
                                  color: const Color(0xFFF59E0B),
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pending Acknowledgments',
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
                                      'Awaiting staff response',
                                      style: TextStyle(
                                        color: const Color(0xFF61738D),
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.43,
                                        letterSpacing: -0.15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('alerts')
                              .where('status', isEqualTo: 'active')
                              .where('requireAcknowledgment', isEqualTo: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            int pendingAcksCount = 0;
                            if (snapshot.hasData) {
                              pendingAcksCount = snapshot.data!.docs.length;
                            }

                            return Text(
                              '$pendingAcksCount',
                              style: TextStyle(
                                color: const Color(0xFF0E162B),
                                fontSize: isSmallScreen ? 20 : 24,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.33,
                                letterSpacing: 0.07,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
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
                  _buildQuickActionsGrid(context, isSmallScreen, padding),
                ],
              ),
            ),
            SizedBox(height: padding),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required Color iconColor,
    required bool isSmallScreen,
    IconData? icon,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 600
        ? (screenWidth - 48) / 2 -
              6 // 2 columns on small screens
        : screenWidth < 900
        ? (screenWidth - 48) / 2 -
              6 // 2 columns on medium screens
        : 197.89; // Fixed width on large screens

    return Container(
      width: cardWidth,
      padding: EdgeInsets.all(16),
      decoration: ShapeDecoration(
        gradient: gradient,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: ShapeDecoration(
                  color: Colors.white.withValues(alpha: 0.20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Icon(
                  icon ?? Icons.info_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withValues(alpha: 0.5),
                size: 12,
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 24 : 30,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.20,
              letterSpacing: 0.40,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: iconColor,
              fontSize: isSmallScreen ? 12 : 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
              letterSpacing: -0.15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(
    BuildContext context,
    bool isSmallScreen,
    double padding,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600
        ? 2 // 2 columns on small screens
        : screenWidth < 900
        ? 2 // 2 columns on medium screens
        : 2; // 2 columns on large screens

    final actions = [
      _QuickAction(
        title: 'Send Alert',
        subtitle: 'Broadcast message',
        iconColor: const Color(0xFFFFECD4),
        icon: Icons.campaign_rounded,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminSendAlertScreen()),
          );
        },
      ),
      _QuickAction(
        title: 'Manage Incidents',
        subtitle: 'Review & resolve',
        iconColor: const Color(0xFFDBEAFE),
        icon: Icons.assignment_rounded,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminAllIncidentsScreen()),
          );
        },
      ),
      _QuickAction(
        title: 'Staff Directory',
        subtitle: 'Manage team',
        iconColor: const Color(0xFFDCFCE7),
        icon: Icons.people_rounded,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminStaffDirectory()),
          );
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isSmallScreen ? 1.2 : 1.4,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return _buildQuickActionCard(context, actions[index], isSmallScreen);
      },
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    _QuickAction action,
    bool isSmallScreen,
  ) {
    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
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
        child: Padding(
          padding: EdgeInsets.all(16.73),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: ShapeDecoration(
                  color: action.iconColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Icon(
                  action.icon,
                  color: const Color(0xFF0E162B),
                  size: 24,
                ),
              ),
              SizedBox(height: 12),
              Flexible(
                child: Text(
                  action.title,
                  style: TextStyle(
                    color: const Color(0xFF0E162B),
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: -0.31,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 4),
              Flexible(
                child: Text(
                  action.subtitle,
                  style: TextStyle(
                    color: const Color(0xFF61738D),
                    fontSize: isSmallScreen ? 12 : 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                    letterSpacing: -0.15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction {
  final String title;
  final String subtitle;
  final Color iconColor;
  final IconData icon;
  final VoidCallback? onTap;

  _QuickAction({
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.icon,
    this.onTap,
  });
}
