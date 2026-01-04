import 'package:flutter/material.dart';
import 'package:work_beacon/screens/admin/admin_dashboard.dart';
import 'package:work_beacon/screens/staff/staff_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:work_beacon/services/profile_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF155DFC), const Color(0xFF193CB8)],
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 15,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Text(
                        'W',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF155CFB),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                          letterSpacing: 0.07,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'WorkBeacon',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                        letterSpacing: 0.40,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Workplace Safety & Communication',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFDAEAFE),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                        letterSpacing: -0.31,
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 50,
                            offset: Offset(0, 25),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign In',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF0E162B),
                              fontSize: 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.33,
                              letterSpacing: 0.07,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildInputField(
                            label: 'Email Address',
                            hint: 'you@company.com',
                            controller: _emailController,
                          ),
                          SizedBox(height: 16),
                          _buildInputField(
                            label: 'Password',
                            hint: '••••••••',
                            obscureText: true,
                            controller: _passwordController,
                          ),
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: const Color(0xFF155CFB),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.15,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    try {
                                      final email = _emailController.text
                                          .trim();
                                      final password = _passwordController.text
                                          .trim();

                                      // Firebase Authentication Sign-In
                                      final userCredential = await FirebaseAuth
                                          .instance
                                          .signInWithEmailAndPassword(
                                            email: email,
                                            password: password,
                                          );

                                      // Initialize user profile if it doesn't exist
                                      if (userCredential.user != null) {
                                        await ProfileService.initializeUserProfile(
                                          userCredential.user!,
                                        );

                                        // Get user profile to determine user type
                                        final profileData =
                                            await ProfileService.getUserProfile(
                                              userCredential.user!.uid,
                                            );

                                        // Check user type from profile, default to staff if not found
                                        final userType =
                                            profileData?['userType'] ?? 'staff';
                                        final isStaff = userType == 'staff';

                                        // Navigate to the appropriate screen based on user role
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => isStaff
                                                ? StaffDashboard()
                                                : AdminDashboard(),
                                          ),
                                        );
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      String errorMessage;

                                      switch (e.code) {
                                        case 'user-not-found':
                                          errorMessage =
                                              'No user found for this email.';
                                          break;
                                        case 'wrong-password':
                                          errorMessage = 'Incorrect password.';
                                          break;
                                        case 'invalid-email':
                                          errorMessage =
                                              'Invalid email address.';
                                          break;
                                        default:
                                          errorMessage =
                                              'An error occurred. Please try again.';
                                      }

                                      // Show error dialog
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Login Failed'),
                                          content: Text(errorMessage),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } catch (e) {
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      // Handle other errors
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Login Failed'),
                                          content: Text(
                                            'An unexpected error occurred.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF155DFC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              disabledBackgroundColor: const Color(
                                0xFF155DFC,
                              ).withOpacity(0.6),
                            ),
                            child: Center(
                              child: _isLoading
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
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: -0.31,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Divider(color: const Color(0xFFE1E8F0)),
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Create Staff Account',
                              style: TextStyle(
                                color: const Color(0xFF314157),
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.31,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildDemoCredentials(context),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '© 2024 WorkBeacon. All rights reserved.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFDAEAFE),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
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
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    bool obscureText = false,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF314157),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            letterSpacing: -0.31,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: const Color(0xFFE1E8F0),
                width: 0.74,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDemoCredentials(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBDDAFF), width: 0.74),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Demo Credentials:',
                style: TextStyle(
                  color: const Color(0xFF314157),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.15,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Staff: staff1@workbeacon.com',
                style: TextStyle(
                  color: const Color(0xFF45556C),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Admin: admin1@workbeacon.com',
                style: TextStyle(
                  color: const Color(0xFF45556C),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Password: abcd1234',
                style: TextStyle(
                  color: const Color(0xFF45556C),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/sign_up');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF155DFC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: EdgeInsets.symmetric(vertical: 14),
          ),
          child: Center(
            child: Text(
              'Create Account',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                letterSpacing: -0.31,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
