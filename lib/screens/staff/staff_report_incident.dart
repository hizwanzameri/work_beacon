import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StaffReportIncident extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Reportincident());
  }
}

class Reportincident extends StatefulWidget {
  @override
  State<Reportincident> createState() => _ReportincidentState();
}

class _ReportincidentState extends State<Reportincident> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _imagePicker = ImagePicker();

  String? _selectedCategory;
  bool _isSubmitting = false;
  XFile? _selectedImage;

  final List<String> _categories = [
    'Safety Hazard',
    'Equipment Malfunction',
    'Security Issue',
    'Maintenance Request',
    'Other',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: ${e.toString()}')),
        );
      }
    }
  }

  Future<String?> _uploadImageToFirebase() async {
    if (_selectedImage == null) return null;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      // Create a unique filename
      final String fileName =
          'incidents/${user.uid}/${DateTime.now().millisecondsSinceEpoch}_${_selectedImage!.name}';

      // Get reference to Firebase Storage
      final Reference storageRef = FirebaseStorage.instance.ref().child(
        fileName,
      );

      // Upload the file
      final UploadTask uploadTask = storageRef.putFile(
        File(_selectedImage!.path),
      );

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: ${e.toString()}')),
        );
      }
      return null;
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an incident category')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to submit a report')),
        );
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      // Upload image if one is selected
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await _uploadImageToFirebase();
      }

      // Add document to staff_incidents collection
      await FirebaseFirestore.instance.collection('staff_incidents').add({
        'category': _selectedCategory,
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        'reportedBy': user.uid,
        'reportedByEmail': user.email,
        'reportedByName': user.displayName ?? 'Unknown',
        'status': 'pending',
        'photoUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incident report submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _descriptionController.clear();
        _locationController.clear();
        setState(() {
          _selectedCategory = null;
          _selectedImage = null;
        });

        // Navigate back after a short delay
        Future.delayed(Duration(seconds: 1), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit report: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final horizontalPadding = isSmallScreen
        ? 16.0
        : (screenWidth * 0.1).clamp(16.0, 48.0);
    final maxContentWidth = isSmallScreen ? double.infinity : 600.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section (Navbar)
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top:
                  MediaQuery.of(context).padding.top +
                  (isSmallScreen ? 12.0 : 16.0),
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: isSmallScreen ? 12.0 : 16.0,
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
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: const Color(0xFF0E162B),
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                // Title
                Expanded(
                  child: Text(
                    'Report Incident',
                    style: TextStyle(
                      color: const Color(0xFF0E162B),
                      fontSize: isSmallScreen ? 20 : 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                      letterSpacing: 0.07,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(horizontalPadding),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        // Incident Category
                        _buildSection(
                          context: context,
                          title: 'Incident Category *',
                          child: Container(
                            width: double.infinity,
                            height: 48,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.74,
                                  color: const Color(0xFFE1E8F0),
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                hint: Text(
                                  'Select category',
                                  style: TextStyle(
                                    color: const Color(0xFF90A1B8),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                isExpanded: true,
                                items: _categories.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        color: const Color(0xFF0E162B),
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Description
                        _buildSection(
                          context: context,
                          title: 'Description *',
                          child: Container(
                            width: double.infinity,
                            constraints: BoxConstraints(minHeight: 120),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.74,
                                  color: const Color(0xFFE1E8F0),
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: TextFormField(
                              controller: _descriptionController,
                              maxLines: null,
                              minLines: 4,
                              decoration: InputDecoration(
                                hintText:
                                    'Provide detailed information about the incident...',
                                hintStyle: TextStyle(
                                  color: const Color(0xFF90A1B8),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                  letterSpacing: -0.31,
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: const Color(0xFF0E162B),
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                                letterSpacing: -0.31,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please provide a description';
                                }
                                if (value.trim().length < 10) {
                                  return 'Description must be at least 10 characters';
                                }
                                return null;
                              },
                            ),
                          ),
                          helperText:
                              'Include what happened, when it occurred, and any other relevant details',
                        ),
                        SizedBox(height: 16),
                        // Upload Photo
                        _buildSection(
                          context: context,
                          title: 'Upload Photo (Optional)',
                          child: Column(
                            children: [
                              if (_selectedImage != null) ...[
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  margin: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      width: 0.74,
                                      color: const Color(0xFFE1E8F0),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.file(
                                      File(_selectedImage!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _selectedImage = null;
                                    });
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  label: Text(
                                    'Remove Photo',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final buttonWidth = isSmallScreen
                                      ? (constraints.maxWidth - 8) / 2
                                      : 176.0;
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: _pickImageFromCamera,
                                          child: _buildPhotoButton(
                                            context: context,
                                            label: 'Take Photo',
                                            width: buttonWidth,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: _pickImageFromGallery,
                                          child: _buildPhotoButton(
                                            context: context,
                                            label: 'From Gallery',
                                            width: buttonWidth,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Location
                        _buildSection(
                          context: context,
                          title: 'Location',
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 50,
                                padding: EdgeInsets.only(
                                  top: 12,
                                  left: 16,
                                  right: 16,
                                  bottom: 12,
                                ),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 0.74,
                                      color: const Color(0xFFE1E8F0),
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: const Color(0xFF90A1B8),
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _locationController,
                                        decoration: InputDecoration(
                                          hintText:
                                              'e.g., Building A - Floor 3, Conference Room B',
                                          hintStyle: TextStyle(
                                            color: const Color(0xFF90A1B8),
                                            fontSize: 16,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -0.31,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          color: const Color(0xFF0E162B),
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: -0.31,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitReport,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isSubmitting
                                  ? const Color(0xFFCAD5E2)
                                  : const Color(0xFF155CFB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 4,
                            ),
                            child: _isSubmitting
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Submit Report',
                                    textAlign: TextAlign.center,
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
                        SizedBox(height: 16),
                        // Info Box
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.73),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEFF6FF),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.74,
                                color: const Color(0xFFBDDAFF),
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'What happens next?',
                                style: TextStyle(
                                  color: const Color(0xFF0E162B),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                  letterSpacing: -0.15,
                                ),
                              ),
                              SizedBox(height: 8),
                              _buildInfoItem(
                                'Admin team will review your report',
                              ),
                              SizedBox(height: 4),
                              _buildInfoItem(
                                'You\'ll receive updates on the incident status',
                              ),
                              SizedBox(height: 4),
                              _buildInfoItem(
                                'Response team may contact you for more details',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required Widget child,
    String? helperText,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF0E162B),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
            letterSpacing: -0.31,
          ),
        ),
        SizedBox(height: 8),
        child,
        if (helperText != null) ...[
          SizedBox(height: 8),
          Text(
            helperText,
            style: TextStyle(
              color: const Color(0xFF61738D),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.33,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPhotoButton({
    required BuildContext context,
    required String label,
    required double width,
  }) {
    return Container(
      width: width,
      height: 112,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.47, color: const Color(0xFFCAD5E2)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            label == 'Take Photo' ? Icons.camera_alt : Icons.photo_library,
            color: const Color(0xFF45556C),
            size: 32,
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF45556C),
              fontSize: 14,
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

  Widget _buildInfoItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF45556C),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
              letterSpacing: -0.15,
            ),
          ),
        ),
      ],
    );
  }
}
