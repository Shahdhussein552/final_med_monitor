import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../models/app_models.dart';
import '../../models/user_profile.dart';
// تم حذف import الـ DynamicCirclePainter القديم
import 'patient_form_screen.dart';
import 'profile_screen.dart';

class PendingAdmissionScreen extends StatefulWidget {
  final List<AdmissionRequest> admissionRequests;
  final UserProfile user;
  final void Function(UserProfile) onUpdate;

  const PendingAdmissionScreen({
    super.key,
    required this.admissionRequests,
    required this.user,
    required this.onUpdate,
  });

  @override
  State<PendingAdmissionScreen> createState() => _PendingAdmissionScreenState();
}

class _PendingAdmissionScreenState extends State<PendingAdmissionScreen> {
  int _selectedIndex = 0;
  late UserProfile _currentLocalUser;

  @override
  void initState() {
    super.initState();
    _currentLocalUser = widget.user;
  }

  String formatTimeAgo(dynamic timeData) {
    if (timeData == null) return "Unknown time";
    try {
      DateTime sentTime = timeData is DateTime ? timeData : DateTime.parse(timeData.toString());
      final difference = DateTime.now().difference(sentTime);
      if (difference.inMinutes < 60) return "${difference.inMinutes} min ago";
      else if (difference.inHours < 24) return "${difference.inHours} hours ago";
      else return "${difference.inDays} days ago";
    } catch (e) { return timeData.toString(); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: _selectedIndex == 1 ? null : AppBar(
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
        elevation: 2,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)
        ),
        title: const Text(
            'Pending Admission Requests',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildRequestsTab(),
          ProfileScreen(
            user: _currentLocalUser,
            onUpdate: (updatedUser) {
              setState(() => _currentLocalUser = updatedUser);
              widget.onUpdate(updatedUser);
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildCurvedBottomNav(context),
    );
  }

  Widget _buildRequestsTab() {
    return widget.admissionRequests.isEmpty
        ? const Center(child: Text("No Pending Requests", style: TextStyle(color: AppColors.darkBlue)))
        : ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      itemCount: widget.admissionRequests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildRequestCard(widget.admissionRequests[index]),
    );
  }

  Widget _buildRequestCard(AdmissionRequest request) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => PatientFormScreen(request: request))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.primaryBlue.withOpacity(0.5), width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(
                    request.doctorName,
                    style: const TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold, fontSize: 16)
                )
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Time Sent ${formatTimeAgo(request.timeSent)}', style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
                const SizedBox(height: 4),
                Text('Patient Name \\ ${request.patientName}', style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurvedBottomNav(BuildContext context) {
    double devW = MediaQuery.of(context).size.width;
    double uW = devW / 2;
    return SizedBox(
      height: 85,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween<double>(begin: 0, end: _selectedIndex.toDouble()),
            builder: (context, v, child) => CustomPaint(
              size: Size(devW, 85),
              painter: DynamicCirclePainter(xOffsetPercent: (v * uW + uW / 2) / devW),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: (_selectedIndex * uW) + (uW / 2) - 28,
            top: 0,
            child: Container(
              width: 56, height: 56,
              decoration: const BoxDecoration(color: Color(0xFF7CA1FF), shape: BoxShape.circle),
              child: Icon(_selectedIndex == 0 ? Icons.home : Icons.person, color: Colors.white, size: 28),
            ),
          ),
          Positioned(
            bottom: 15, width: devW,
            child: Row(
              children: [
                _buildNavItem(0, Icons.home_outlined),
                _buildNavItem(1, Icons.person_outline),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int i, IconData ic) => Expanded(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _selectedIndex = i),
      child: Opacity(
        opacity: _selectedIndex == i ? 0 : 1,
        child: Icon(ic, color: Colors.white, size: 28),
      ),
    ),
  );
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
