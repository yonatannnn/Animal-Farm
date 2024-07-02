import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:micro/models/cowModel.dart';
import 'package:micro/screens/cowDetailScreen.dart';
import 'package:micro/services/cowService.dart';

class EditCowScreen extends StatefulWidget {
  final Cow cow;

  EditCowScreen({required this.cow});

  @override
  _EditCowScreenState createState() => _EditCowScreenState();
}

class _EditCowScreenState extends State<EditCowScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _firstDateOfMatingController = TextEditingController();
  List<TextEditingController> _datesOfGiveBirthControllers = [];

  final CowService _cowService = CowService();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.cow.name;
    _dateOfBirthController.text =
        widget.cow.dateOfBirth.toLocal().toString().split(' ')[0];
    _firstDateOfMatingController.text = widget.cow.firstDateOfMating.join(', ');
    _datesOfGiveBirthControllers = widget.cow.dateOfGiveBirth
        .map((date) =>
            TextEditingController(text: DateFormat('yyyy-MM-dd').format(date)))
        .toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateOfBirthController.dispose();
    _firstDateOfMatingController.dispose();
    _datesOfGiveBirthControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Cow', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTextField(_nameController, 'Name', 'Enter cow name'),
            SizedBox(height: 20),
            _buildTextField(_dateOfBirthController,
                'Date of Birth (YYYY-MM-DD)', 'Enter date of birth'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCow,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  void _saveCow() async {
    if (_nameController.text.isNotEmpty &&
        _dateOfBirthController.text.isNotEmpty) {
      final name = _nameController.text;
      final dateOfBirth = DateTime.parse(_dateOfBirthController.text);
      final firstDateOfMating = _firstDateOfMatingController.text
          .split(',')
          .map((e) => e.trim())
          .toList();
      final datesOfGiveBirth = _datesOfGiveBirthControllers
          .map((controller) => DateTime.parse(controller.text))
          .toList();

      widget.cow.name = name;
      widget.cow.dateOfBirth = dateOfBirth;
      widget.cow.firstDateOfMating = firstDateOfMating;
      widget.cow.dateOfGiveBirth = datesOfGiveBirth;

      try {
        await _cowService.updateCow(widget.cow);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CowDetailScreen(cowId: widget.cow.id)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update cow'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
    }
  }
}
