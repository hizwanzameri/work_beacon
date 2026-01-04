import 'package:flutter/material.dart';
import 'package:work_beacon/screens/staff/staff_alert_details.dart';

class StaffAlertHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Alerthistory());
  }
}

class Alerthistory extends StatefulWidget {
  @override
  _AlerthistoryState createState() => _AlerthistoryState();
}

class _AlerthistoryState extends State<Alerthistory> {
  String _selectedFilter = 'All';

  // Sample alert data
  final List<Map<String, dynamic>> _allAlerts = [
    {
      'type': 'Emergency',
      'title': 'Building Evacuation Required',
      'description':
          'Due to a fire alarm activation in Building A, all staff must evacuate immediately. Please proceed to the designated assembly point in Parking Lot C.',
      'time': '5 min ago',
      'backgroundColor': const Color(0xFFFFECD4),
      'borderColor': const Color(0xFFFFD6A7),
      'textColor': const Color(0xFFC93400),
    },
    {
      'type': 'Safety',
      'title': 'Wet Floor - Warehouse Bay 7',
      'description':
          'Spilled liquid creating slip hazard near loading dock. Area has been cordoned off. Please use alternative routes.',
      'time': '1 hour ago',
      'backgroundColor': const Color(0xFFFEF9C2),
      'borderColor': const Color(0xFFFEEF85),
      'textColor': const Color(0xFFA65F00),
    },
    {
      'type': 'Info',
      'title': 'System Maintenance Tonight',
      'description':
          'The WorkBeacon system will be undergoing scheduled maintenance tonight from 10 PM to 2 AM. Please plan accordingly.',
      'time': '3 hours ago',
      'backgroundColor': const Color(0xFFDBEAFE),
      'borderColor': const Color(0xFFBDDAFF),
      'textColor': const Color(0xFF1447E6),
    },
  ];

  List<Map<String, dynamic>> get _filteredAlerts {
    if (_selectedFilter == 'All') {
      return _allAlerts;
    }
    return _allAlerts
        .where((alert) => alert['type'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;
    final padding = isSmallScreen ? 12.0 : 16.0;
    final spacing = isSmallScreen ? 12.0 : 16.0;

    return Container(
      width: double.infinity,
      height: screenHeight,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Navbar Row with Back Button and Title
                Row(
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
                        'Alert History',
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
                SizedBox(height: spacing),
                // Filter Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FilterButton(
                        label: 'All',
                        isSelected: _selectedFilter == 'All',
                        padding: padding,
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'All';
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      _FilterButton(
                        label: 'Emergency',
                        isSelected: _selectedFilter == 'Emergency',
                        padding: padding,
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'Emergency';
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      _FilterButton(
                        label: 'Safety',
                        isSelected: _selectedFilter == 'Safety',
                        padding: padding,
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'Safety';
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      _FilterButton(
                        label: 'Info',
                        isSelected: _selectedFilter == 'Info',
                        padding: padding,
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'Info';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Content Section
          Expanded(
            child: _filteredAlerts.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        'No alerts found',
                        style: TextStyle(
                          color: const Color(0xFF45556C),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._filteredAlerts.asMap().entries.map((entry) {
                          final index = entry.key;
                          final alert = entry.value;
                          return Column(
                            children: [
                              if (index > 0) SizedBox(height: spacing),
                              _AlertCard(
                                type: alert['type'],
                                title: alert['title'],
                                description: alert['description'],
                                time: alert['time'],
                                backgroundColor: alert['backgroundColor'],
                                borderColor: alert['borderColor'],
                                textColor: alert['textColor'],
                                padding: padding,
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final double padding;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.padding,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF155DFC) : const Color(0xFFF1F5F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF45556C),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
              letterSpacing: -0.15,
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final String type;
  final String title;
  final String description;
  final String time;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double padding;

  const _AlertCard({
    required this.type,
    required this.title,
    required this.description,
    required this.time,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StaffAlertDetails(
              type: type,
              title: title,
              description: description,
              time: time,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(padding + 2),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.47, color: borderColor),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
                letterSpacing: -0.31,
              ),
            ),
            SizedBox(height: 12),
            // Description
            Opacity(
              opacity: 0.75,
              child: Text(
                description,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                  letterSpacing: -0.15,
                ),
              ),
            ),
            SizedBox(height: 12),
            // Time
            Opacity(
              opacity: 0.60,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time, size: 12, color: textColor),
                  SizedBox(width: 8),
                  Text(
                    time,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
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
}
