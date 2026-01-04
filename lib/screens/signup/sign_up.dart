// Flutter imports:
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _agree = false;
  bool _loading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agree) {
      _showMessage(
        'You must agree to the Terms of Service and Privacy Policy.',
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final auth = FirebaseAuth.instance;
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final userCred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name with full name
      if (userCred.user != null) {
        await userCred.user!.updateDisplayName(_fullNameController.text.trim());
        await userCred.user!.reload();
        
        // Initialize user profile with form data
        await _initializeUserProfile(userCred.user!);
      }

      // Optionally send email verification
      try {
        await auth.currentUser?.sendEmailVerification();
      } catch (_) {}

      if (!mounted) return;
      _showMessage(
        'Account created. Please check your email for verification.',
      );
      Navigator.of(context).pop(); // or navigate to next screen
    } on FirebaseAuthException catch (e) {
      String msg = 'Failed to register.';
      if (e.code == 'email-already-in-use') msg = 'Email already in use.';
      if (e.code == 'weak-password') msg = 'Password is too weak.';
      if (e.code == 'invalid-email') msg = 'Invalid email address.';
      _showMessage(msg);
    } catch (e) {
      _showMessage('An unexpected error occurred.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _initializeUserProfile(User user) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final profileRef = firestore.collection('staff_profiles').doc(user.uid);
      
      // Check if profile already exists
      final profileDoc = await profileRef.get();
      
      if (!profileDoc.exists) {
        // Create new profile with form data
        await profileRef.set({
          'uid': user.uid,
          'email': user.email ?? '',
          'fullName': _fullNameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'department': '',
          'position': '',
          'staffId': '',
          'userType': 'staff', // Default to staff for signup page
          'joinDate': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Profile exists, update with form data if needed
        await profileRef.update({
          'fullName': _fullNameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'userType': 'staff', // Ensure userType is set to staff for signup page
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      // Log error but don't throw - allow registration to proceed
      print('Error initializing user profile: $e');
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
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
            height: 1.50,
            letterSpacing: -0.31,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: placeholder,
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.00, 0.00),
                            end: Alignment(1.00, 1.00),
                            colors: [
                              const Color(0xFF155CFB),
                              const Color(0xFF193BB8),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Back to Login',
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
                                  const SizedBox(height: 16),
                                  Center(
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
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
                                          child: Text(
                                            'W',
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
                                        const SizedBox(height: 16),
                                        Text(
                                          'Create Staff Account',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 1.33,
                                            letterSpacing: 0.07,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Join the WorkBeacon platform',
                                          style: TextStyle(
                                            color: const Color(0xFFDAEAFE),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 50,
                                offset: Offset(0, 25),
                                spreadRadius: -12,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildInputField(
                                  controller: _fullNameController,
                                  label: 'Full Name *',
                                  placeholder: 'John Doe',
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty)
                                      return 'Enter full name';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                buildInputField(
                                  controller: _phoneController,
                                  label: 'Phone Number *',
                                  placeholder: '(555) 123-4567',
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 16),
                                buildInputField(
                                  controller: _emailController,
                                  label: 'Email Address *',
                                  placeholder: 'you@company.com',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty)
                                      return 'Enter email';
                                    if (!v.contains('@'))
                                      return 'Enter a valid email';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                buildInputField(
                                  controller: _passwordController,
                                  label: 'Password *',
                                  placeholder: '••••••••',
                                  obscureText: true,
                                  validator: (v) {
                                    if (v == null || v.length < 6)
                                      return 'Password must be at least 6 characters';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                buildInputField(
                                  controller: _confirmController,
                                  label: 'Confirm Password *',
                                  placeholder: '••••••••',
                                  obscureText: true,
                                  validator: (v) {
                                    if (v != _passwordController.text)
                                      return 'Passwords do not match';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: _agree,
                                      onChanged: (v) =>
                                          setState(() => _agree = v ?? false),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'I agree to the Terms of Service and Privacy Policy. I understand that my account requires HR approval before activation.',
                                        style: TextStyle(
                                          color: const Color(0xFF314157),
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
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _loading ? null : _register,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF155DFC),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                    child: _loading
                                        ? SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            'Register',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 1.50,
                                              letterSpacing: -0.31,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Already have an account? Sign In',
                          style: TextStyle(
                            color: const Color(0xFFDAEAFE),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
