import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'baby_profile_model.dart';
import 'parent_profile_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

final babyListProvider = StateNotifierProvider<BabyListNotifier, List<BabyProfile>>((ref) => BabyListNotifier());
final selectedBabyIndexProvider = StateProvider<int>((ref) => 0);
final parentProfileProvider = StateNotifierProvider<ParentProfileNotifier, ParentProfile?>((ref) => ParentProfileNotifier());

// Add color to BabyProfile (if not present, you may need to update the model and Hive type)
const List<Color> babyColors = [
  Colors.pink,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.teal,
  Colors.red,
  Colors.brown,
  Colors.cyan,
];

class BabyListNotifier extends StateNotifier<List<BabyProfile>> {
  BabyListNotifier() : super([]) {
    _loadBabies();
  }

  Future<void> _loadBabies() async {
    final box = await Hive.openBox<BabyProfile>('babyProfileBox');
    state = box.values.toList();
  }

  Future<void> addBaby(BabyProfile baby) async {
    final box = await Hive.openBox<BabyProfile>('babyProfileBox');
    await box.add(baby);
    state = box.values.toList();
  }

  Future<void> updateBaby(int index, BabyProfile baby) async {
    final box = await Hive.openBox<BabyProfile>('babyProfileBox');
    await box.putAt(index, baby);
    state = box.values.toList();
  }

  Future<void> deleteBaby(int index) async {
    final box = await Hive.openBox<BabyProfile>('babyProfileBox');
    await box.deleteAt(index);
    state = box.values.toList();
  }
}

class ParentProfileNotifier extends StateNotifier<ParentProfile?> {
  ParentProfileNotifier() : super(null) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final box = await Hive.openBox<ParentProfile>('parentProfileBox');
    if (box.isNotEmpty) {
      state = box.getAt(0);
    }
  }

  Future<void> saveProfile(ParentProfile profile) async {
    final box = await Hive.openBox<ParentProfile>('parentProfileBox');
    if (box.isNotEmpty) {
      await box.putAt(0, profile);
    } else {
      await box.add(profile);
    }
    state = profile;
  }
}

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final babies = ref.watch(babyListProvider);
    final selectedIndex = ref.watch(selectedBabyIndexProvider);
    final parent = ref.watch(parentProfileProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20)),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Babies'),
            Tab(text: 'Parent'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Babies Tab
          Column(
            children: [
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: babies.length + 1,
                  itemBuilder: (context, i) {
                    if (i == babies.length) {
                      return _AddBabyCard(onAdd: (baby) => ref.read(babyListProvider.notifier).addBaby(baby));
                    }
                    final baby = babies[i];
                    return GestureDetector(
                      onTap: () => ref.read(selectedBabyIndexProvider.notifier).state = i,
                      child: Card(
                        color: selectedIndex == i ? Colors.teal[100] : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(8),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage: baby.photoPath != null ? FileImage(File(baby.photoPath!)) : null,
                                  child: baby.photoPath == null ? const Icon(Icons.child_care, size: 28) : null,
                                ),
                                const SizedBox(height: 8),
                                Text(baby.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 18),
                                  onPressed: () => ref.read(babyListProvider.notifier).deleteBaby(i),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (babies.isNotEmpty)
                Expanded(
                  child: _BabyDetailSection(
                    baby: babies[selectedIndex],
                    onSave: (baby) => ref.read(babyListProvider.notifier).updateBaby(selectedIndex, baby),
                  ),
                ),
            ],
          ),
          // Parent Tab
          _ParentProfileSection(
            parent: parent,
            onSave: (profile) => ref.read(parentProfileProvider.notifier).saveProfile(profile),
          ),
        ],
      ),
    );
  }
}

class _AddBabyCard extends StatelessWidget {
  final void Function(BabyProfile) onAdd;
  const _AddBabyCard({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final baby = await showDialog<BabyProfile>(
            context: context,
            builder: (context) => _BabyDialog(),
          );
          if (baby != null) onAdd(baby);
        },
        child: SizedBox(
          width: 100,
          child: Center(child: Icon(Icons.add, size: 36, color: Colors.teal)),
        ),
      ),
    );
  }
}

class _BabyDialog extends StatefulWidget {
  final BabyProfile? initial;
  const _BabyDialog({this.initial});

  @override
  State<_BabyDialog> createState() => _BabyDialogState();
}

class _BabyDialogState extends State<_BabyDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _gender;
  DateTime? _dob;
  int? _age;
  double? _weight;
  String? _photoPath;
  String? _feedingType;
  String? _allergies;
  String? _medicalHistory;
  String? _birthComplications;
  Color _selectedColor = babyColors[0];

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _name = widget.initial!.name;
      _gender = widget.initial!.gender;
      _dob = widget.initial!.dob;
      _age = widget.initial!.age;
      _weight = widget.initial!.weight;
      _photoPath = widget.initial!.photoPath;
      // Optionals (if you add to model)
      if ((widget.initial as dynamic).color != null) {
        _selectedColor = (widget.initial as dynamic).color;
      }
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _photoPath = picked.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial == null ? 'Add Baby' : 'Edit Baby', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20)),
      content: SizedBox(
        width: 350,
        height: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 80,
                  child: Lottie.asset('assets/lottie/baby.json', repeat: false),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickPhoto,
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: _selectedColor,
                    backgroundImage: _photoPath != null ? FileImage(File(_photoPath!)) : null,
                    child: _photoPath == null ? const Icon(Icons.camera_alt, size: 32) : null,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Color'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 32,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: babyColors.map((color) => GestureDetector(
                            onTap: () => setState(() => _selectedColor = color),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedColor == color ? Colors.black : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          )).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                  onSaved: (v) => _name = v,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (v) => setState(() => _gender = v),
                  validator: (v) => v == null ? 'Select gender' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: TextEditingController(text: _dob != null ? _dob!.toIso8601String().split('T').first : ''),
                  decoration: const InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _dob ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => _dob = picked);
                  },
                  validator: (v) => _dob == null ? 'Select DOB' : null,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.pop(
                context,
                BabyProfile(
                  name: _name!,
                  gender: _gender!,
                  dob: _dob!,
                  age: _age ?? 0,
                  weight: _weight ?? 0.0,
                  photoPath: _photoPath,
                  // Optionals can be added to model if desired
                  // Add color if model supports it
                  // color: _selectedColor,
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _BabyDetailSection extends StatelessWidget {
  final BabyProfile baby;
  final void Function(BabyProfile) onSave;
  const _BabyDetailSection({required this.baby, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: baby.photoPath != null ? FileImage(File(baby.photoPath!)) : null,
                    child: baby.photoPath == null ? const Icon(Icons.child_care, size: 32) : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(baby.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('Gender: ${baby.gender}'),
                      Text('DOB: ${baby.dob.toIso8601String().split('T').first}'),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final edited = await showDialog<BabyProfile>(
                        context: context,
                        builder: (context) => _BabyDialog(initial: baby),
                      );
                      if (edited != null) onSave(edited);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Growth Chart (Weight)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Get AI Insights'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                    onPressed: () async {
                      final aiResult = await showDialog<String>(
                        context: context,
                        builder: (context) => _AIInsightsDialog(baby: baby),
                      );
                      if (aiResult != null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('AI Insights'),
                            content: Text(aiResult),
                            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 120,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: [FlSpot(0, baby.weight)], // TODO: Use real data
                        isCurved: true,
                        color: Colors.teal,
                        barWidth: 4,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Milestones', style: TextStyle(fontWeight: FontWeight.bold)),
              _MilestoneChecklist(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AIInsightsDialog extends StatefulWidget {
  final BabyProfile baby;
  const _AIInsightsDialog({required this.baby});

  @override
  State<_AIInsightsDialog> createState() => _AIInsightsDialogState();
}

class _AIInsightsDialogState extends State<_AIInsightsDialog> {
  bool loading = true;
  String? result;

  @override
  void initState() {
    super.initState();
    _fetchAI();
  }

  Future<void> _fetchAI() async {
    // TODO: Replace with real TinyLlama/Gemini call
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      result = "AI says: Your baby's growth is on track! (Stub)";
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Getting AI Insights...'),
      content: loading
          ? const SizedBox(height: 60, child: Center(child: CircularProgressIndicator()))
          : Text(result ?? 'No result'),
      actions: [if (!loading) TextButton(onPressed: () => Navigator.pop(context, result), child: const Text('OK'))],
    );
  }
}

class _MilestoneChecklist extends StatefulWidget {
  @override
  State<_MilestoneChecklist> createState() => _MilestoneChecklistState();
}

class _MilestoneChecklistState extends State<_MilestoneChecklist> {
  final List<String> milestones = [
    'First Smile',
    'First Word',
    'First Step',
    'Sits Up',
    'Crawls',
    'Waves Bye',
  ];
  late List<bool> checked;

  @override
  void initState() {
    super.initState();
    checked = List.filled(milestones.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(milestones.length, (i) => CheckboxListTile(
        value: checked[i],
        onChanged: (v) => setState(() => checked[i] = v ?? false),
        title: Text(milestones[i], style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      )),
    );
  }
}

class _ParentProfileSection extends StatelessWidget {
  final ParentProfile? parent;
  final void Function(ParentProfile) onSave;
  const _ParentProfileSection({required this.parent, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: parent?.photoPath != null ? FileImage(File(parent!.photoPath!)) : null,
                  child: parent?.photoPath == null ? const Icon(Icons.person, size: 32) : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(parent?.name ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(parent?.email ?? ''),
                    Text(parent?.phone ?? ''),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final edited = await showDialog<ParentProfile>(
                      context: context,
                      builder: (context) => _ParentDialog(initial: parent),
                    );
                    if (edited != null) onSave(edited);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ParentDialog extends StatefulWidget {
  final ParentProfile? initial;
  const _ParentDialog({this.initial});

  @override
  State<_ParentDialog> createState() => _ParentDialogState();
}

class _ParentDialogState extends State<_ParentDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _phone;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _name = widget.initial!.name;
      _email = widget.initial!.email;
      _phone = widget.initial!.phone;
      _photoPath = widget.initial!.photoPath;
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _photoPath = picked.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial == null ? 'Add Parent' : 'Edit Parent', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickPhoto,
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: _photoPath != null ? FileImage(File(_photoPath!)) : null,
                  child: _photoPath == null ? const Icon(Icons.camera_alt, size: 32) : null,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                onSaved: (v) => _name = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v == null || v.isEmpty ? 'Enter email' : null,
                onSaved: (v) => _email = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (v) => v == null || v.isEmpty ? 'Enter phone' : null,
                onSaved: (v) => _phone = v,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.pop(
                context,
                ParentProfile(
                  name: _name!,
                  email: _email!,
                  phone: _phone!,
                  photoPath: _photoPath,
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
} 