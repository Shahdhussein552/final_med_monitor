import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/user_profile.dart';
import 'custom_drawer.dart';
// تم حذف import الـ DynamicCirclePainter القديم
import 'profile_screen.dart';

class SuperAdminScreen extends StatefulWidget {
  final UserProfile user;
  final Function(UserProfile) onUpdate;
  final List<StatCardData>? initialStats;
  final List<AgeGroupData>? initialAgeGroups;

  const SuperAdminScreen({
    super.key,
    required this.user,
    required this.onUpdate,
    this.initialStats,
    this.initialAgeGroups,
  });

  @override
  State<SuperAdminScreen> createState() => _SuperAdminScreenState();
}

class _SuperAdminScreenState extends State<SuperAdminScreen> {
  static const Color _primaryBlue = Color(0xFF2E55A7);
  int _selectedIndex = 0;

  late UserProfile _currentUser;
  bool _isLoading = true;
  late List<StatCardData> _currentStats;
  late List<AgeGroupData> _currentAgeGroups;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;

    _currentStats = widget.initialStats ?? [
      StatCardData(value: 0, label: 'Occupied Beds'),
      StatCardData(value: 0, label: 'Available Beds'),
      StatCardData(value: 0, label: 'Total Patients'),
      StatCardData(value: 0, label: 'Total Doctors'),
      StatCardData(value: 0, label: 'Total Nurses'),
      StatCardData(value: 0, label: 'Total Requests'),
    ];

    _currentAgeGroups = widget.initialAgeGroups ?? [
      AgeGroupData(title: 'Newborns', range: '0-28 Days', count: 0, imagePath: 'assets/newborn(1).png'),
      AgeGroupData(title: 'Children', range: '1-12 Years', count: 0, imagePath: 'assets/children (1).png'),
      AgeGroupData(title: 'Teenagers', range: '13-19 Years', count: 0, imagePath: 'assets/teenagers (1).png'),
      AgeGroupData(title: 'Adults', range: '20-64 Years', count: 0, imagePath: 'assets/adults(1).png'),
      AgeGroupData(title: 'Elderly', range: '65+ Years', count: 0, imagePath: 'assets/elderly (1).png'),
    ];

    _fetchDashboardData();
  }

  void _handleUserUpdate(UserProfile updatedUser) {
    setState(() {
      _currentUser = updatedUser;
    });
    widget.onUpdate(updatedUser);
  }

  Future<void> _fetchDashboardData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _currentStats = [
        StatCardData(value: 36, label: 'Occupied Beds'),
        StatCardData(value: 16, label: 'Available Beds'),
        StatCardData(value: 36, label: 'Total Patients'),
        StatCardData(value: 15, label: 'Total Doctors'),
        StatCardData(value: 22, label: 'Total Nurses'),
        StatCardData(value: 50, label: 'Total Requests'),
      ];
      _currentAgeGroups = [
        AgeGroupData(title: 'Newborns', range: '0-28 Days', count: 3, imagePath: 'assets/newborn(1).png'),
        AgeGroupData(title: 'Children', range: '1-12 Years', count: 1, imagePath: 'assets/children (1).png'),
        AgeGroupData(title: 'Teenagers', range: '13-19 Years', count: 2, imagePath: 'assets/teenagers (1).png'),
        AgeGroupData(title: 'Adults', range: '20-64 Years', count: 4, imagePath: 'assets/adults(1).png'),
        AgeGroupData(title: 'Elderly', range: '65+ Years', count: 6, imagePath: 'assets/elderly (1).png'),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF3FF),
      endDrawer: CustomSideDrawer(
        user: _currentUser,
        onUpdate: _handleUserUpdate,
        onProfileBack: () => setState(() => _selectedIndex = 0),
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHomeScreen(),
              ProfileScreen(
                user: _currentUser,
                onUpdate: _handleUserUpdate,
                isEmbedded: true,
              ),
            ],
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildCurvedBottomNav(context)),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetchDashboardData,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: _primaryBlue))
                : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                child: Column(children: [
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.8,
                    children: _currentStats.map((s) => _buildStatCard(s)).toList(),
                  ),
                  const SizedBox(height: 35),
                  const Text("Statistics of Patients' Ages Inside\nthe Hospital",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _primaryBlue, fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 25),
                  _buildAgeGrid(),
                  const SizedBox(height: 35),
                  _buildPendingButton(),
                ]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF719EFF),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          const CircleAvatar(radius: 20, backgroundImage: AssetImage('assets/super admin (1).png')),
          const SizedBox(width: 12),
          Expanded(child: Text(_currentUser.name, style: const TextStyle(color: _primaryBlue, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
          Builder(builder: (c) => IconButton(icon: const Icon(Icons.menu, color: Colors.white, size: 28), onPressed: () => Scaffold.of(c).openEndDrawer())),
        ]),
      ),
    );
  }

  Widget _buildStatCard(StatCardData s) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(
            color: Color(0xFFCADBFF),
            border: Border.fromBorderSide(BorderSide(color: Color(0xFF8AAAF5), width: 1.3)),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          alignment: Alignment.center,
          child: Text('${s.value}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 6),
        Text(s.label, textAlign: TextAlign.center, style: const TextStyle(color: _primaryBlue, fontSize: 10, fontWeight: FontWeight.w600, height: 1.1)),
      ],
    );
  }

  Widget _buildAgeGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: _currentAgeGroups.map((group) => _buildAgeCardItem(group)).toList(),
    );
  }

  Widget _buildAgeCardItem(AgeGroupData g) {
    double cardWidth = (MediaQuery.of(context).size.width - 50) / 2;
    if (cardWidth > 185) cardWidth = 185;
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFCADBFF),
        border: Border.fromBorderSide(BorderSide(color: Color(0xFF8AAAF5), width: 1.3)),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(22), topRight: Radius.circular(22), bottomRight: Radius.circular(22)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundColor: Colors.white, child: ClipOval(child: Image.asset(g.imagePath, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.person, size: 18)))),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text(g.title, style: const TextStyle(color: _primaryBlue, fontSize: 11, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis), Text(g.range, style: const TextStyle(color: _primaryBlue, fontSize: 8)), Text('${g.count}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900))])),
        ],
      ),
    );
  }

  Widget _buildPendingButton() {
    return SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(onPressed: () => Navigator.pushNamed(context, '/pending_requests'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF719EFF), elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), icon: const Icon(Icons.assignment_outlined, color: Colors.white, size: 24), label: const Text('Pending Admission Requests', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900))));
  }

  Widget _buildCurvedBottomNav(BuildContext context) {
    double devW = MediaQuery.of(context).size.width;
    double uW = devW / 2;
    return Container(
      height: 80,
      color: Colors.transparent,
      child: Stack(clipBehavior: Clip.none, children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween<double>(begin: 0, end: _selectedIndex.toDouble()),
          builder: (context, v, child) => CustomPaint(size: Size(devW, 80), painter: DynamicCirclePainter(xOffsetPercent: (v * uW + uW / 2) / devW)),
        ),
        AnimatedPositioned(duration: const Duration(milliseconds: 300), left: (_selectedIndex * uW) + (uW / 2) - 28, top: 0, child: Container(width: 56, height: 56, decoration: const BoxDecoration(color: Color(0xFF7CA1FF), shape: BoxShape.circle), child: Icon(_selectedIndex == 0 ? Icons.home : Icons.person, color: Colors.white, size: 28))),
        Positioned(bottom: 10, width: devW, child: Row(children: [_buildNavItem(0, Icons.home_outlined), _buildNavItem(1, Icons.person_outline)]))
      ]),
    );
  }

  Widget _buildNavItem(int i, IconData ic) => Expanded(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => setState(() => _selectedIndex = i), child: Opacity(opacity: _selectedIndex == i ? 0 : 1, child: Icon(ic, color: Colors.white, size: 28))));
}

// --- إضافة الكلاس هنا في نهاية الملف ---
class DynamicCirclePainter extends CustomPainter {
  final double xOffsetPercent;
  DynamicCirclePainter({required this.xOffsetPercent});

  @override
  void paint(Canvas canvas, Size size) {
    Paint p = Paint()..color = const Color(0xFF719EFF)..style = PaintingStyle.fill;
    double r = 38;
    double x = size.width * xOffsetPercent;
    Path path = Path()
      ..moveTo(0, 30)..lineTo(x - r - 10, 30)
      ..quadraticBezierTo(x - r, 30, x - r, 30 - 5)
      ..arcToPoint(Offset(x + r, 30 - 5), radius: Radius.circular(r), clockwise: false)
      ..quadraticBezierTo(x + r, 30, x + r + 10, 30)
      ..lineTo(size.width, 30)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(path, p);
  }
  @override
  bool shouldRepaint(DynamicCirclePainter old) => old.xOffsetPercent != xOffsetPercent;
}
