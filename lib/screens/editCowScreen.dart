import 'package:flutter/material.dart';
import 'package:micro/models/cowModel.dart';
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

  final CowService _cowService = CowService();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.cow.name;
    _dateOfBirthController.text =
        widget.cow.dateOfBirth.toLocal().toString().split(' ')[0];
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _dateOfBirthController.dispose();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_nameController, 'Name', 'Enter cow name'),
            SizedBox(height: 20),
            _buildTextField(_dateOfBirthController,
                'Date of Birth (YYYY-MM-DD)', 'Enter date of birth'),
            SizedBox(height: 20),
            _buildDatesOfGiveBirth(),
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

  Widget _buildDatesOfGiveBirth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dates of Give Birth',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (int i = 0; i < widget.cow.dateOfGiveBirth.length; i++)
              Chip(
                label: Text(
                  widget.cow.dateOfGiveBirth[i]
                      .toLocal()
                      .toString()
                      .split(' ')[0],
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue,
                deleteButtonTooltipMessage: 'Remove this date',
                onDeleted: () {
                  setState(() {
                    widget.cow.dateOfGiveBirth.removeAt(i);
                  });
                },
              ),
          ],
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: _addDateOfGiveBirth,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
          child: Text('Add Date of Give Birth'),
        ),
      ],
    );
  }

  void _addDateOfGiveBirth() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        widget.cow.dateOfGiveBirth.add(selectedDate);
      });
    }
  }

  void _saveCow() async {
    // Validate fields and update cow details
    if (_nameController.text.isNotEmpty &&
        _dateOfBirthController.text.isNotEmpty) {
      final name = _nameController.text;
      final dateOfBirth = DateTime.parse(_dateOfBirthController.text);

      // Update cow object
      widget.cow.name = name;
      widget.cow.dateOfBirth = dateOfBirth;

      try {
        await _cowService.updateCow(widget.cow);
        Navigator.pop(context); // Close the edit screen
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
