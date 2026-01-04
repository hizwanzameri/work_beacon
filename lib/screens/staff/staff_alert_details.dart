import 'package:flutter/material.dart';

class StaffAlertDetails extends StatelessWidget {
  final String type;
  final String title;
  final String description;
  final String time;

  const StaffAlertDetails({
    Key? key,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDetails(
        type: type,
        title: title,
        description: description,
        time: time,
      ),
    );
  }
}

class AlertDetails extends StatelessWidget {
  final String type;
  final String title;
  final String description;
  final String time;

  const AlertDetails({
    Key? key,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
  }) : super(key: key);

  Color _getHeaderColor() {
    switch (type.toUpperCase()) {
      case 'EMERGENCY':
        return const Color(0xFFF54900);
      case 'SAFETY':
        return const Color(0xFFD08700);
      case 'INFO':
        return const Color(0xFF155DFC);
      default:
        return const Color(0xFFF54900);
    }
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = _getHeaderColor();
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 853.05,
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 179.95,
                decoration: BoxDecoration(color: headerColor),
                child: Stack(
                  children: [
                    Positioned(
                      left: 23.99,
                      top: 23.99,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 23.99,
                          height: 23.99,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 23.99,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 23.99,
                      top: 63.98,
                      child: Container(
                        width: 344.71,
                        height: 23.99,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 8,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.white,
                              size: 23.99,
                            ),
                            Opacity(
                              opacity: 0.90,
                              child: Container(
                                width: 88,
                                height: 19.99,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0.47,
                                      child: Text(
                                        type.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 1.43,
                                          letterSpacing: 0.20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 23.99,
                      top: 95.97,
                      child: Container(
                        width: 344.71,
                        height: 32,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: -0.53,
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                  letterSpacing: 0.07,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 23.99,
                      top: 135.97,
                      child: Opacity(
                        opacity: 0.75,
                        child: Container(
                          width: 344.71,
                          height: 19.99,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 2,
                                child: Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                  size: 15.99,
                                ),
                              ),
                              Positioned(
                                left: 23.99,
                                top: 0.47,
                                child: SizedBox(
                                  width: 127,
                                  child: Text(
                                    'Received $time',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.43,
                                      letterSpacing: -0.15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 381.83,
                padding: const EdgeInsets.only(
                  top: 15.99,
                  left: 15.99,
                  right: 15.99,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15.99,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 172.42,
                      padding: const EdgeInsets.only(
                        top: 16.73,
                        left: 16.73,
                        right: 16.73,
                        bottom: 0.74,
                      ),
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
                        spacing: 8,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 27,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0.21,
                                  child: Text(
                                    'Alert Message',
                                    style: TextStyle(
                                      color: const Color(0xFF0E162B),
                                      fontSize: 18,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 1.50,
                                      letterSpacing: -0.44,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 103.96,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: -1.06,
                                  child: SizedBox(
                                    width: 326,
                                    child: Text(
                                      description,
                                      style: TextStyle(
                                        color: const Color(0xFF314157),
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.63,
                                        letterSpacing: -0.31,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 89.44,
                      padding: const EdgeInsets.only(
                        top: 16.73,
                        left: 16.73,
                        right: 16.73,
                        bottom: 0.74,
                      ),
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
                        spacing: 8,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 23.99,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 2,
                                  child: Icon(
                                    Icons.location_on,
                                    color: const Color(0xFF0E162B),
                                    size: 19.99,
                                  ),
                                ),
                                Positioned(
                                  left: 27.99,
                                  top: -0.79,
                                  child: Text(
                                    'Location',
                                    style: TextStyle(
                                      color: const Color(0xFF0E162B),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                      letterSpacing: -0.31,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 23.99,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: -0.79,
                                  child: Text(
                                    'Building A',
                                    style: TextStyle(
                                      color: const Color(0xFF314157),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                      letterSpacing: -0.31,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 55.98,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF00A63E),
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
                      child: Stack(
                        children: [
                          Positioned(
                            left: 98.40,
                            top: 17.99,
                            child: Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                              size: 19.99,
                            ),
                          ),
                          Positioned(
                            left: 125.39,
                            top: 15.20,
                            child: Text(
                              'Acknowledge Alert',
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
    );
  }
}
