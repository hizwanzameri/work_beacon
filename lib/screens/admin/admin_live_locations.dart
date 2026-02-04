import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Dummy map center (e.g. office / campus).
const LatLng _mapCenter = LatLng(5.5164233762165455, 100.43691119528009);

/// Radius in degrees to scatter staff markers around the center (~1–2 km).
const double _markerRadiusDeg = 0.012;

/// Dummy staff with fixed names; positions are assigned randomly near center.
final List<DummyStaffLocation> _dummyStaffList = [
  DummyStaffLocation(name: 'Ahmad Rahman', role: 'Field Technician'),
  DummyStaffLocation(name: 'Siti Nurhaliza', role: 'Safety Officer'),
  DummyStaffLocation(name: 'Raj Kumar', role: 'Site Supervisor'),
  DummyStaffLocation(name: 'Lee Wei Ming', role: 'Engineer'),
  DummyStaffLocation(name: 'Nurul Izzati', role: 'Field Technician'),
  DummyStaffLocation(name: 'Mohammad Hafiz', role: 'Safety Officer'),
  DummyStaffLocation(name: 'Chen Wei Jie', role: 'Site Supervisor'),
  DummyStaffLocation(name: 'Fatimah Hassan', role: 'Engineer'),
  DummyStaffLocation(name: 'David Tan', role: 'Field Technician'),
  DummyStaffLocation(name: 'Aisha Ibrahim', role: 'Safety Officer'),
];

class DummyStaffLocation {
  DummyStaffLocation({required this.name, required this.role, LatLng? position})
    : position = position ?? _randomNearCenter();

  final String name;
  final String role;
  final LatLng position;

  static final Random _random = Random();

  static LatLng _randomNearCenter() {
    final angle = _random.nextDouble() * 2 * pi;
    final r = _random.nextDouble() * _markerRadiusDeg;
    final lat = _mapCenter.latitude + r * cos(angle);
    final lng = _mapCenter.longitude + r * sin(angle);
    return LatLng(lat, lng);
  }
}

/// Custom map marker widget: white circle with green border, blue gradient
/// inner circle with initials, and green online indicator dot.
class StaffMapMarkerWidget extends StatelessWidget {
  const StaffMapMarkerWidget({super.key, required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 3.68, color: Color(0xFF00C850)),
              borderRadius: BorderRadius.circular(24),
            ),
            shadows: [
              const BoxShadow(
                color: Color(0x19000000),
                blurRadius: 6,
                offset: Offset(0, 4),
                spreadRadius: -4,
              ),
              const BoxShadow(
                color: Color(0x19000000),
                blurRadius: 15,
                offset: Offset(0, 10),
                spreadRadius: -3,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 40.64,
                  height: 40.64,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(0.00, 0.00),
                      end: Alignment(1.00, 1.00),
                      colors: [Color(0xFF2B7FFF), Color(0xFF155CFB)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.32),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Text(
                    initials,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF00C850),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.47, color: Colors.white),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminLiveLocationsScreen extends StatefulWidget {
  const AdminLiveLocationsScreen({super.key});

  @override
  State<AdminLiveLocationsScreen> createState() =>
      _AdminLiveLocationsScreenState();
}

class _AdminLiveLocationsScreenState extends State<AdminLiveLocationsScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final DraggableScrollableController _drawerController =
      DraggableScrollableController();
  bool _showOffline = false;
  List<DummyStaffLocation> _staff = [];
  List<DummyStaffLocation> _filteredStaff = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initStaff();
    _applyFilters();
  }

  void _initStaff() {
    _staff = _dummyStaffList
        .map((s) => DummyStaffLocation(name: s.name, role: s.role))
        .toList();
  }

  void _applyFilters() {
    var list = List<DummyStaffLocation>.from(_staff);
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where(
            (s) =>
                s.name.toLowerCase().contains(q) ||
                s.role.toLowerCase().contains(q),
          )
          .toList();
    }
    if (_showOffline) {
      // For dummy data we show all; in real app you'd filter by online/offline.
    }
    setState(() => _filteredStaff = list);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _drawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final padding = isSmallScreen ? 12.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, padding, isSmallScreen),
            Expanded(
              child: Stack(
                children: [
                  _buildMap(context),
                  _buildStaffBottomDrawer(context, padding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    double padding,
    bool isSmallScreen,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: padding,
        left: padding,
        right: padding,
        bottom: padding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x19000000),
            blurRadius: 2,
            offset: const Offset(0, 1),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: const Color(0x19000000),
            blurRadius: 3,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live Locations',
            style: TextStyle(
              color: const Color(0xFF0E162B),
              fontSize: isSmallScreen ? 20 : 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFE1E8F0),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) {
                      setState(() {
                        _searchQuery = v;
                        _applyFilters();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search staff...',
                      hintStyle: TextStyle(
                        color: const Color(0xFF45556C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: const Color(0xFF61738D),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    style: TextStyle(
                      color: const Color(0xFF0E162B),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: _showOffline
                    ? const Color(0xFF00C850).withValues(alpha: 0.15)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _showOffline = !_showOffline;
                      _applyFilters();
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFE1E8F0),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Show Offline',
                      style: TextStyle(
                        color: _showOffline
                            ? const Color(0xFF00C850)
                            : const Color(0xFF45556C),
                        fontSize: 14,
                        fontWeight: _showOffline
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    final mapboxToken = dotenv.env['MAPBOX_ACCESS_TOKEN']?.trim();

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        if (w <= 0 || h <= 0) {
          return const SizedBox.expand(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (mapboxToken == null || mapboxToken.isEmpty) {
          return SizedBox(
            width: w,
            height: h,
            child: Container(
              color: const Color(0xFFF1F5F9),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map_outlined, size: 48, color: Colors.grey[600]),
                    const SizedBox(height: 16),
                    Text(
                      'Mapbox token required',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add MAPBOX_ACCESS_TOKEN to your .env file\n(copy from .env.example)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return SizedBox(
          width: w,
          height: h,
          child: ClipRRect(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _mapCenter,
                initialZoom: 15.0,
                minZoom: 12,
                maxZoom: 18,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}?access_token={accessToken}',
                  additionalOptions: {'accessToken': mapboxToken},
                  userAgentPackageName: 'com.example.work_beacon',
                ),
                MarkerLayer(
                  markers: [
                    _centerMarker(),
                    ..._filteredStaff.map(_staffMarker),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Marker _centerMarker() {
    return Marker(
      point: _mapCenter,
      width: 56,
      height: 56,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF00C850), width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x19000000),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.location_on,
              color: const Color(0xFF00C850),
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Office',
            style: TextStyle(
              fontSize: 11,
              color: const Color(0xFF0E162B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Marker _staffMarker(DummyStaffLocation staff) {
    return Marker(
      point: staff.position,
      width: 48,
      height: 48,
      child: StaffMapMarkerWidget(initials: _initials(staff.name)),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts.first[0] + parts.last[0]).toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Widget _buildStaffBottomDrawer(BuildContext context, double padding) {
    return DraggableScrollableSheet(
      controller: _drawerController,
      initialChildSize: 0.18,
      minChildSize: 0.12,
      maxChildSize: 0.65,
      snap: true,
      snapSizes: const [0.18, 0.45, 0.65],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: const Color(0x1A000000),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Row(
                  children: [
                    Text(
                      'Staff on map',
                      style: TextStyle(
                        color: const Color(0xFF0E162B),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_filteredStaff.length}',
                        style: const TextStyle(
                          color: Color(0xFF61738D),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _filteredStaff.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'No staff match your search.',
                            style: TextStyle(
                              color: const Color(0xFF61738D),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: EdgeInsets.fromLTRB(
                          padding,
                          0,
                          padding,
                          padding + MediaQuery.of(context).padding.bottom,
                        ),
                        itemCount: _filteredStaff.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final staff = _filteredStaff[index];
                          return _StaffListTile(
                            staff: staff,
                            initials: _initials(staff.name),
                            onTap: () =>
                                _mapController.move(staff.position, 17),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StaffListTile extends StatelessWidget {
  const _StaffListTile({
    required this.staff,
    required this.initials,
    required this.onTap,
  });

  final DummyStaffLocation staff;
  final String initials;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF00C850),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staff.name,
                      style: const TextStyle(
                        color: Color(0xFF0E162B),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      staff.role,
                      style: const TextStyle(
                        color: Color(0xFF61738D),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C850).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Online',
                  style: TextStyle(
                    color: Color(0xFF00C850),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
