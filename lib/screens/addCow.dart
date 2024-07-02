import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:micro/models/cowModel.dart';
import 'package:micro/services/cowService.dart';

class AddCowScreen extends StatefulWidget {
  @override
  _AddCowScreenState createState() => _AddCowScreenState();
}

class _AddCowScreenState extends State<AddCowScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final CowService _cowService = CowService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add Cow',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                      _nameController, 'Name', 'Please enter a name'),
                  SizedBox(height: 20),
                  _buildTextField(
                      _dateOfBirthController,
                      'Date of Birth (YYYY-MM-DD)',
                      'Please enter a date of birth'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveCow,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      String validationMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }

  Future<void> _saveCow() async {
    if (_formKey.currentState?.validate() ?? false) {
      final id = FirebaseFirestore.instance.collection('cows').doc().id;
      final name = _nameController.text;
      final dateOfBirth = DateTime.parse(_dateOfBirthController.text);

      final cow = Cow(
          id: id,
          name: name,
          dateOfBirth: dateOfBirth,
          firstDateOfMating: [],
          milkProduction: [],
          dateOfGiveBirth: []);
      try {
        await _cowService.saveCow(cow);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Cow added successfully')));
        _dateOfBirthController.clear();
        _nameController.clear();
      } catch (e) {
        throw Exception('Error');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }
}
