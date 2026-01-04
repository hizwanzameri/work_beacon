// Flutter imports:
import 'package:flutter/material.dart';
import 'package:work_beacon/screens/staff/staff_incident_details.dart';

class IncidentCard extends StatelessWidget {
  final String title;
  final String id;
  final String status;
  final String description;
  final String location;
  final String date;
  final String? photoUrl;
  final String documentId;

  const IncidentCard({
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StaffIncidentDetails(
              title: title,
              id: id,
              status: status,
              description: description,
              location: location,
              date: date,
              photoUrl: photoUrl,
              documentId: documentId,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16), // Add padding for spacing
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
        child: Column(
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
            const SizedBox(height: 4),
            Text(
              id,
              style: TextStyle(
                color: const Color(0xFF61738D),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.43,
                letterSpacing: -0.15,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                color: const Color(0xFF45556C),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.43,
                letterSpacing: -0.15,
              ),
            ),
            if (photoUrl != null && photoUrl!.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  photoUrl!,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 150,
                      color: const Color(0xFFF8FAFC),
                      child: Icon(
                        Icons.broken_image,
                        color: const Color(0xFFE1E8F0),
                        size: 48,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 150,
                      color: const Color(0xFFF8FAFC),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  location,
                  style: TextStyle(
                    color: const Color(0xFF90A1B8),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
                Text(
                  date,
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
          ],
        ),
      ),
    );
  }
}
