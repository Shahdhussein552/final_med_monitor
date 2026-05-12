import 'package:flutter/material.dart';
import '../../models/patient_model.dart';
import '../../models/app_models.dart';
// تأكدي من أن هذا المسار يشير إلى الملف الذي وضعتِ فيه كود MonitorScreen الاحترافي
import '../../features/doctor/monitor_screen.dart';
import '../../features/doctor/chat_screen.dart';
import '../../features/doctor/patient_reports_screen.dart';
import '../../features/doctor/personal_data_screen.dart';
import '../../features/nurse/nurse_tasks_screen.dart';
import '../../features/doctor/vital_signs_screen.dart';

class PatientDetailScreen extends StatelessWidget {
  final PatientData patient;
  const PatientDetailScreen({super.key, required this.patient});

  static const Color _primaryBlue = Color(0xFF719EFF);
  static const Color _cardBgColor = Color(0xFFCADBFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF3FF),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildMonitorCard(),
                  const SizedBox(height: 40),
                  _buildMenuGrid(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    patient.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 26),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonitorCard() {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        // التعديل الأساسي هنا: نمرر كائن المريض كاملاً ليتوافق مع النسخة الاحترافية
        child: MonitorScreen(patient: patient),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final AdmissionRequest finalData = AdmissionRequest(
      patientName: patient.name,
      doctorName: "Unknown",
      timeSent: "",
      id: "N/A",
      age: "N/A",
      phone: "N/A",
      gender: "N/A",
      height: "N/A",
      weight: "N/A",
    );

    final List<Map<String, dynamic>> menuItems = [
      {
        'label': 'Personal data',
        'img': 'assets/personal data (1).png',
        'page': PersonalDataScreen(request: finalData),
      },
      {
        'label': 'Vital signs',
        'img': 'assets/vital signs (1).png',
        'page': const VitalSignsScreen(),
      },
      {
        'label': 'Patient Reports',
        'img': 'assets/patient reports(1).png',
        'page': const PatientReportsScreen(),
      },
      {
        'label': 'Tasks',
        'img': 'assets/tasks (1).png',
        // هنا يتم توجيه الممرضة لمهامها الخاصة
        'page': const NurseTaskScreen(true),
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: menuItems.map((item) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => item['page'] as Widget),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: _cardBgColor,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Image.asset(
                      item['img'],
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item['label'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF2E55A7),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
