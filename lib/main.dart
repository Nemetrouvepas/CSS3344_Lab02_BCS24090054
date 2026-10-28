import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const Lab02App());
}

class Lab02App extends StatelessWidget {
  const Lab02App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.cyan,
      ),
      home: const Lab02HomeScreen(),
    );
  }
}

class Lab02HomeScreen extends StatefulWidget {
  const Lab02HomeScreen({super.key});

  @override
  State<Lab02HomeScreen> createState() => _Lab02HomeScreenState();
}

class _Lab02HomeScreenState extends State<Lab02HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedRole = 'Student';

  // --- Picker Functions ---

  // 1. Material Date Picker
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal[600]!,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 2. Cupertino Date Picker (Modal Sheet)
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _selectedDate,
          maximumDate: DateTime.now(),
          onDateTimeChanged: (DateTime newDate) {
            setState(() => _selectedDate = newDate);
          },
        ),
      ),
    );
  }

  // 3. Cupertino Role Picker (Wheel)
  void _showCupertinoRolePicker(BuildContext context) {
    final List<String> roles = ['Student', 'Developer', 'Designer'];
    final int initialIndex = roles.indexOf(_selectedRole);

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 200,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
            initialItem: initialIndex >= 0 ? initialIndex : 0,
          ),
          onSelectedItemChanged: (int index) {
            setState(() => _selectedRole = roles[index]);
          },
          children: roles.map((role) => Center(child: Text(role))).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CSS3344 Mobile App Dev - Lab 02',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan[100]?.withOpacity(0.9),
        foregroundColor: Colors.teal[900],
      ),
      body: Stack(
        children: [
          // 1. Full-Screen Background Image with 60% Opacity Effect
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/bg2.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Adaptive Screen Content
          OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.portrait
                  ? _buildPortraitView()
                  : _buildLandscapeView();
            },
          ),
        ],
      ),
    );
  }

  // --- Portrait View Layout ---
  Widget _buildPortraitView() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24.0),
      children: [
        const StudentDetailsSection(
          name: 'SHAHDAYANA SYERINA BINTI KHUSRIN SHAH',
          studentId: 'BCS24090054',
          quote: '"Life is only as good as your mindset"',
          imagePath: 'assets/dayana.jpeg',
        ),
        const TitleSection(
          name: 'Moraine Lake',
          location: 'Banff National Park, Canada',
          starCount: 5,
        ),
        const ImageSection(imagePath: 'assets/lake.jpg'),
        _buildPickersSection(),
      ],
    );
  }

  // --- Landscape View Layout ---
  Widget _buildLandscapeView() {
    return Row(
      children: [
        const Expanded(
          child: SingleChildScrollView(
            child: StudentDetailsSection(
              name: 'SHAHDAYANA SYERINA BINTI KHUSRIN SHAH',
              studentId: 'BCS24090054',
              quote: '"Life is only as good as your mindset"',
              imagePath: 'assets/dayana.jpeg',
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24.0),
            children: [
              const TitleSection(
                name: 'Moraine Lake',
                location: 'Banff National Park, Canada',
                starCount: 5,
              ),
              const ImageSection(imagePath: 'assets/lake.jpg'),
              _buildPickersSection(),
            ],
          ),
        ),
      ],
    );
  }

  // --- Pickers Control Section ---
  Widget _buildPickersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Card(
        color: Colors.white.withOpacity(0.92),
        elevation: 3,
        shadowColor: Colors.teal.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interactive Pickers (Material vs Cupertino)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              Divider(height: 24, color: Colors.cyan[100]),

              // Date Displays & Triggers
              Text(
                'Selected Date: ${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan[100],
                        foregroundColor: Colors.teal[900],
                        elevation: 0,
                      ),
                      onPressed: () => _selectMaterialDate(context),
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('Material Date'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.teal[700],
                        side: BorderSide(color: Colors.cyan[300]!),
                      ),
                      onPressed: () => _showCupertinoDatePicker(context),
                      icon: const Icon(CupertinoIcons.calendar),
                      label: const Text('Cupertino Date'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Selection Triggers
              Text(
                'Selected Role: $_selectedRole',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Material Dropdown
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedRole,
                      iconEnabledColor: Colors.teal[400],
                      items: ['Student', 'Developer', 'Designer']
                          .map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() => _selectedRole = newValue);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Cupertino Wheel Picker Trigger
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.teal[700],
                        side: BorderSide(color: Colors.cyan[300]!),
                      ),
                      onPressed: () => _showCupertinoRolePicker(context),
                      child: const Text('Cupertino Wheel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- ImageSection Widget ---
class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          imagePath,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// --- Exercise 2.1: Deconstructed TitleSection Widget ---
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.88),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: TextStyle(color: Colors.teal[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.star, color: Colors.cyan[600]),
            const SizedBox(width: 4),
            Text('$starCount',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// --- Student Details Card (Ocean Blue / Cyan Vibe) ---
class StudentDetailsSection extends StatelessWidget {
  final String name;
  final String studentId;
  final String quote;
  final String imagePath;

  const StudentDetailsSection({
    super.key,
    required this.name,
    required this.studentId,
    required this.quote,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Card(
        color: const Color(0xFF007A87).withOpacity(0.95), // Deep Ocean Teal
        elevation: 6,
        shadowColor: Colors.teal.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.cyan[100]!, width: 3),
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage(imagePath),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Student ID: $studentId',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.cyan[100],
                ),
              ),
              const Divider(height: 28, color: Colors.white30),
              const Text(
                'Personal Life Goal / Quote:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0F7FA),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                quote,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}