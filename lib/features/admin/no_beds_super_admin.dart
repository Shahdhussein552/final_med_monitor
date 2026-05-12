import 'package:flutter/material.dart';
import 'dart:math';
import '../../models/patient_model.dart';

// --- هذا هو الكود الذي طلبتيه بالضبط مع التعديلات الداخلية فقط ---

class BedsScreen extends StatefulWidget {
  final PatientBed? newPatient;
  const BedsScreen({super.key, this.newPatient});

  @override
  State<BedsScreen> createState() => _BedsScreenState();
}

class _BedsScreenState extends State<BedsScreen> with TickerProviderStateMixin {
  // الألوان والتنسيقات الثابتة (كما هي في كودك)
  static const Color _headerBlue = Color(0xFF719EFF);
  static const Color _mainBgColor = Color(0xFFEDF3FF);
  static const Color _sharpFrameColor = Color(0xFF8DAEF2);
  static const Color _numberGrey = Color(0xFF626262);
  static const Color _redDelete = Color(0xFFE53935);
  static const Color _whiteBtnBg = Color(0xFFFFFFFF);
  static const Color _pureBlack = Color(0xFF000000);

  late List<PatientBed> _activePatients;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    // متحكم الحركة للموجات
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // قائمة المرضى الأولية (تم إصلاح الـ age هنا لمنع الإيرور)
    _activePatients = [
      const PatientBed(name: 'Ahmed', age: 25, nurse: 'Soha', illness: 'Cancer'),
      const PatientBed(name: 'Ali', age: 31, nurse: 'Soha', illness: 'Heart attack'),
      const PatientBed(name: 'Mona', age: 20, nurse: 'Mahmoud', illness: 'Broken'),
    ];

    if (widget.newPatient != null) {
      _activePatients.add(widget.newPatient!);
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _addNewPatient() {
    if (_activePatients.length < 5) {
      setState(() {
        _activePatients.add(
          const PatientBed(
              name: 'New Patient',
              age: 0,
              nurse: 'Not Assigned',
              illness: 'General Checkup'
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _mainBgColor,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              children: [
                ..._activePatients.map((patient) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildOccupiedBedCard(patient),
                )),
                if (_activePatients.length < 5) _buildEmptyBedCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: _headerBlue,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    children: [
                      const TextSpan(text: 'Beds : ', style: TextStyle(color: Colors.white)),
                      TextSpan(text: '${_activePatients.length}', style: const TextStyle(color: _numberGrey)),
                      const TextSpan(text: ' / 5', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOccupiedBedCard(PatientBed patient) {
    return Container(
      decoration: BoxDecoration(
        color: _mainBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _sharpFrameColor, width: 2.5),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(13.5)),
            child: Container(
              height: 150,
              width: double.infinity,
              color: _pureBlack,
              child: _buildFakeMonitor(), // نستخدم الدالة التي طلبتِها
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildInfoItem('Name: ', patient.name)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildInfoItem('Age: ', '${patient.age}')),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _buildInfoItem('Nurse: ', patient.nurse)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildInfoItem('Illness: ', patient.illness)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _activePatients.remove(patient);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _whiteBtnBg,
                    foregroundColor: _redDelete,
                    elevation: 1,
                    side: const BorderSide(color: _redDelete, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text('Delete Patient', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.black)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildEmptyBedCard() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: _mainBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _sharpFrameColor, width: 2.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No Patient added yet',
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Opacity(
            opacity: 0.25,
            child: Icon(Icons.hotel, size: 80, color: _headerBlue),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _addNewPatient,
            icon: const Icon(Icons.add, size: 18, color: Colors.white),
            label: const Text('Click to add patient',
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _headerBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  // الدالة التي طلبتِ استخدامها بالضبط مع إضافة الـ AnimationBuilder بداخلها
  Widget _buildFakeMonitor() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Stack(
          children: [
            // رسم الموجات الاحترافية الثلاثة
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _waveRow(WaveType.ecg, const Color(0xFF00FF88)),
                  _waveRow(WaveType.brain, const Color(0xFF719EFF)),
                  _waveRow(WaveType.resp, const Color(0xFFFFD54F)),
                ],
              ),
            ),
            // الملصقات (Labels) كما في كودك الأصلي
            const Positioned(
              top: 10,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MonitorLabel(value: '74', unit: 'BPM', color: Color(0xFF00FF88)),
                  MonitorLabel(value: '65', unit: '%SpO2', color: Color(0xFF719EFF)),
                  MonitorLabel(value: '34', unit: 'RESP', color: Color(0xFFFFD54F)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _waveRow(WaveType type, Color color) {
    return Expanded(
      child: CustomPaint(
        size: Size.infinite,
        painter: WavePainter(type: type, color: color, phase: _waveController.value),
      ),
    );
  }
}

// --- الكلاسات المساعدة (بدون أي تغيير في الأسماء) ---

class MonitorLabel extends StatelessWidget {
  final String value, unit;
  final Color color;
  const MonitorLabel({super.key, required this.value, required this.unit, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        const SizedBox(width: 4),
        Text(unit, style: TextStyle(color: color, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
      ],
    );
  }
}

enum WaveType { ecg, brain, resp }

class WavePainter extends CustomPainter {
  final WaveType type;
  final Color color;
  final double phase;

  WavePainter({required this.type, required this.color, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 2.0..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path();
    final double w = size.width;
    final double h = size.height;
    final double mid = h / 2;

    if (type == WaveType.ecg) {
      double step = w / 3;
      for (double i = -1; i < 3; i++) {
        double x = (i * step + (phase * w)) % (w + step) - (step * 0.5);
        path.moveTo(x, mid);
        path.lineTo(x + step * 0.1, mid);
        path.lineTo(x + step * 0.15, mid - h * 0.4);
        path.lineTo(x + step * 0.2, mid + h * 0.3);
        path.lineTo(x + step * 0.25, mid);
        path.lineTo(x + step * 0.5, mid);
      }
    } else if (type == WaveType.brain) {
      for (double i = 0; i <= w; i++) {
        double y = mid + sin((i * 0.5) + (phase * 20)) * 3 + cos((i * 0.8)) * 2;
        if (i == 0) path.moveTo(i, y); else path.lineTo(i, y);
      }
    } else {
      for (double i = 0; i <= w; i++) {
        double y = mid + sin((i * 0.1) + (phase * 10)) * (h * 0.3);
        if (i == 0) path.moveTo(i, y); else path.lineTo(i, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}
