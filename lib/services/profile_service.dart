import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service class for managing user profiles
class ProfileService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initializes user profile after login
  /// Creates a profile in staff_profiles collection if it doesn't exist
  /// Returns true if profile was created, false if it already existed
  static Future<bool> initializeUserProfile(User user) async {
    try {
      // Check if profile already exists
      final profileDoc = await _firestore
          .collection('staff_profiles')
          .doc(user.uid)
          .get();

      if (profileDoc.exists) {
        // Profile already exists, no need to create
        return false;
      }

      // Extract name from displayName or email
      String fullName = user.displayName ?? '';
      if (fullName.isEmpty) {
        // Try to extract name from email
        final emailParts = user.email?.split('@')[0] ?? 'User';
        fullName = emailParts
            .split(RegExp(r'[._-]'))
            .map((part) => part.isEmpty
                ? ''
                : part[0].toUpperCase() + part.substring(1))
            .join(' ');
      }

      // Determine user type from email (fallback logic for existing users)
      String userType = 'staff'; // Default to staff
      final email = user.email?.toLowerCase() ?? '';
      if (email.contains('admin') || email == 'admin@workbeacon.com') {
        userType = 'admin';
      }

      // Create new profile with default values
      await _firestore.collection('staff_profiles').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email ?? '',
        'fullName': fullName,
        'phone': '',
        'department': '',
        'position': '',
        'staffId': '',
        'userType': userType,
        'joinDate': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      // Log error but don't throw - allow login to proceed
      print('Error initializing user profile: $e');
      return false;
    }
  }

  /// Gets user profile data
  static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final profileDoc =
          await _firestore.collection('staff_profiles').doc(uid).get();
      if (profileDoc.exists) {
        return profileDoc.data();
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }
}

