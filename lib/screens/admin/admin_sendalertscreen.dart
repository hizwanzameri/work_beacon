import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminSendAlertScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Alert'), backgroundColor: Colors.white),
      body: Sendalertscreen(),
    );
  }
}

class Sendalertscreen extends StatefulWidget {
  @override
  State<Sendalertscreen> createState() => _SendalertscreenState();
}

class _SendalertscreenState extends State<Sendalertscreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _departmentController = TextEditingController();
  final _imagePicker = ImagePicker();

  String? _selectedAlertType;
  String? _selectedSendTo; // 'all' or 'department'
  bool _requireAcknowledgment = false;
  XFile? _selectedImage;
  bool _isSubmitting = false;

  final List<String> _departments = [
    'IT',
    'HR',
    'Finance',
    'Operations',
    'Sales',
    'Marketing',
    'Engineering',
    'Support',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _departmentController.dispose();
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
          'alerts/${user.uid}/${DateTime.now().millisecondsSinceEpoch}_${_selectedImage!.name}';

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

  Future<void> _submitAlert() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAlertType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select an alert type')));
      return;
    }

    if (_selectedSendTo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select who to send the alert to')),
      );
      return;
    }

    if (_selectedSendTo == 'department' &&
        _departmentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select a department')));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to send an alert')),
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

      // Prepare alert data
      Map<String, dynamic> alertData = {
        'alertType': _selectedAlertType,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        'sendTo': _selectedSendTo == 'all'
            ? 'all'
            : _departmentController.text.trim(),
        'requireAcknowledgment': _requireAcknowledgment,
        'imageUrl': imageUrl,
        'createdBy': user.uid,
        'createdByEmail': user.email,
        'createdByName': user.displayName ?? 'Admin',
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active',
      };

      // Add document to alerts collection
      await FirebaseFirestore.instance.collection('alerts').add(alertData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alert sent successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _titleController.clear();
        _descriptionController.clear();
        _locationController.clear();
        _departmentController.clear();
        setState(() {
          _selectedAlertType = null;
          _selectedSendTo = null;
          _requireAcknowledgment = false;
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
            content: Text('Failed to send alert: ${e.toString()}'),
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
    final horizontalPadding = isSmallScreen ? 16.0 : 24.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(horizontalPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    // Alert Type Section
                    _buildAlertTypeSection(context),
                    SizedBox(height: 16),
                    // Alert Title Section
                    _buildTextFieldSection(
                      label: 'Alert Title *',
                      hint: 'e.g., Building Evacuation Required',
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an alert title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // Description Section
                    _buildDescriptionSection(),
                    SizedBox(height: 16),
                    // Image Upload Section
                    _buildImageUploadSection(),
                    SizedBox(height: 16),
                    // Location Section
                    _buildLocationSection(),
                    SizedBox(height: 16),
                    // Send To Section
                    _buildSendToSection(),
                    if (_selectedSendTo == 'department') ...[
                      SizedBox(height: 16),
                      _buildDepartmentSection(),
                    ],
                    SizedBox(height: 16),
                    // Acknowledgment Section
                    _buildAcknowledgmentSection(),
                    SizedBox(height: 16),
                    // Send Button
                    _buildSendButton(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertTypeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alert Type *',
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
        Row(
          children: [
            Expanded(child: _buildAlertTypeButton('Emergency')),
            SizedBox(width: 8),
            Expanded(child: _buildAlertTypeButton('Safety')),
            SizedBox(width: 8),
            Expanded(child: _buildAlertTypeButton('Info')),
          ],
        ),
      ],
    );
  }

  IconData _getAlertTypeIcon(String label) {
    switch (label) {
      case 'Emergency':
        return Icons.warning_rounded;
      case 'Safety':
        return Icons.shield_rounded;
      case 'Info':
        return Icons.info_rounded;
      default:
        return Icons.circle;
    }
  }

  Widget _buildAlertTypeButton(String label) {
    final isSelected = _selectedAlertType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAlertType = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.47,
              color: isSelected
                  ? const Color(0xFF155CFB)
                  : const Color(0xFFE1E8F0),
            ),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              _getAlertTypeIcon(label),
              color: isSelected
                  ? const Color(0xFF155CFB)
                  : const Color(0xFF45556C),
              size: 24,
            ),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF155CFB)
                    : const Color(0xFF45556C),
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
    );
  }

  Widget _buildTextFieldSection({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.74, color: const Color(0xFFE1E8F0)),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
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
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description *',
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
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 120),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.74, color: const Color(0xFFE1E8F0)),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: TextFormField(
            controller: _descriptionController,
            maxLines: null,
            minLines: 4,
            decoration: InputDecoration(
              hintText: 'Provide detailed information about the alert...',
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
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Image (Optional)',
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
        if (_selectedImage != null) ...[
          Container(
            width: double.infinity,
            height: 200,
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(width: 0.74, color: const Color(0xFFE1E8F0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(File(_selectedImage!.path), fit: BoxFit.cover),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedImage = null;
              });
            },
            icon: Icon(Icons.delete, color: Colors.red),
            label: Text('Remove Image', style: TextStyle(color: Colors.red)),
          ),
          SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _pickImageFromCamera,
                child: Container(
                  height: 112,
                  padding: EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.47,
                        color: const Color(0xFFCAD5E2),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: const Color(0xFF45556C),
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Take Photo',
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
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: _pickImageFromGallery,
                child: Container(
                  height: 112,
                  padding: EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.47,
                        color: const Color(0xFFCAD5E2),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library,
                        color: const Color(0xFF45556C),
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'From Gallery',
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
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location (Optional)',
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
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.74, color: const Color(0xFFE1E8F0)),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, color: const Color(0xFF90A1B8), size: 20),
              SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Building A - Floor 3, Conference Room B',
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
      ],
    );
  }

  Widget _buildSendToSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Send To *',
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
        _buildSendToOption('All Staff', '247 employees', 'all'),
        SizedBox(height: 8),
        _buildSendToOption('Specific Department', 'Select below', 'department'),
      ],
    );
  }

  Widget _buildSendToOption(String title, String subtitle, String value) {
    final isSelected = _selectedSendTo == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSendTo = value;
          if (value != 'department') {
            _departmentController.clear();
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.74,
              color: isSelected
                  ? const Color(0xFF155CFB)
                  : const Color(0xFFE1E8F0),
            ),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF155CFB)
                          : const Color(0xFF0E162B),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                      letterSpacing: -0.31,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: const Color(0xFF61738D),
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
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: const Color(0xFF155CFB),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Department *',
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
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.74, color: const Color(0xFFE1E8F0)),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _departmentController.text.trim().isEmpty
                  ? null
                  : _departmentController.text.trim(),
              hint: Text(
                'Select department',
                style: TextStyle(
                  color: const Color(0xFF90A1B8),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              isExpanded: true,
              items: _departments.map((String department) {
                return DropdownMenuItem<String>(
                  value: department,
                  child: Text(
                    department,
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
                  _departmentController.text = newValue ?? '';
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAcknowledgmentSection() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _requireAcknowledgment = !_requireAcknowledgment;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: const Color(0xFFEFF6FF),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.74, color: const Color(0xFFBDDAFF)),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _requireAcknowledgment,
              onChanged: (bool? value) {
                setState(() {
                  _requireAcknowledgment = value ?? false;
                });
              },
              activeColor: const Color(0xFF155CFB),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Require Acknowledgment',
                    style: TextStyle(
                      color: const Color(0xFF0E162B),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                      letterSpacing: -0.31,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Staff must acknowledge receipt of this alert',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    final buttonText = _selectedSendTo == 'department'
        ? 'Send Alert to Department'
        : 'Send Alert to All Staff';

    return GestureDetector(
      onTap: _isSubmitting ? null : _submitAlert,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: ShapeDecoration(
          color: _isSubmitting
              ? const Color(0xFFCAD5E2)
              : const Color(0xFF155CFB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          shadows: _isSubmitting
              ? []
              : [
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
        child: Center(
          child: _isSubmitting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  buttonText,
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
    );
  }
}
