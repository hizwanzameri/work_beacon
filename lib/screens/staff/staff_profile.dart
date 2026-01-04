import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:work_beacon/login/login.dart';
import 'staff_profile_edit.dart';

class StaffProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Staffprofile());
  }
}

class Staffprofile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;
    final padding = isSmallScreen ? 16.0 : 24.0;

    return Container(
      width: double.infinity,
      height: screenHeight,
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC)),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 16,
                left: padding,
                right: padding,
                bottom: 16,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Icon(Icons.arrow_back, size: 24),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'My Profile',
                        style: TextStyle(
                          color: const Color(0xFF0E162B),
                          fontSize: isSmallScreen ? 20 : 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                          letterSpacing: 0.07,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StaffProfileEdit(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: const Color(0xFF155CFB),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Edit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF155CFB),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: -0.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
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
                                'SJ',
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
                            'Sarah Johnson',
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
                            'Operations Manager',
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
                            'Staff ID: WB-12001',
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
                            value: 'Sarah Johnson',
                          ),
                          SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: 'sarah.johnson@workbeacon.com',
                          ),
                          SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.phone_outlined,
                            label: 'Phone',
                            value: '(555) 123-4567',
                          ),
                          SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.business_outlined,
                            label: 'Department',
                            value: 'Operations',
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
                          _buildDetailRow('Join Date', 'January 15, 2023'),
                          SizedBox(height: 8),
                          _buildDetailRow('Position', 'Operations Manager'),
                          SizedBox(height: 8),
                          _buildDetailRow('Staff ID', 'WB-12001'),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: isSmallScreen ? 50 : 56,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFE7000B),
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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            // Show confirmation dialog
                            final shouldLogout = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Logout'),
                                content: Text(
                                  'Are you sure you want to logout?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: const Color(0xFFE7000B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (shouldLogout == true) {
                              try {
                                // Sign out from Firebase
                                await FirebaseAuth.instance.signOut();

                                // Navigate to login screen and clear navigation stack
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                  (route) => false,
                                );
                              } catch (e) {
                                // Show error if logout fails
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error logging out: ${e.toString()}',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Logout',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
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
                        ),
                      ),
                    ),
                    SizedBox(height: padding),
                  ],
                ),
              ),
            ),
          ],
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
