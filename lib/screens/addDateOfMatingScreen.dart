import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:micro/models/cowModel.dart';
import 'package:micro/screens/cowDetailScreen.dart';
import 'package:micro/widgets/drawer.dart';

class AddDateOfMatingScreen extends StatefulWidget {
  final Cow cow;

  AddDateOfMatingScreen({required this.cow});

  @override
  _AddDateOfMatingScreenState createState() => _AddDateOfMatingScreenState();
}

class _AddDateOfMatingScreenState extends State<AddDateOfMatingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _saveDateOfMating() async {
    if (_formKey.currentState!.validate()) {
      String dateText = _dateController.text;
      DateTime date = DateTime.tryParse(dateText)!;

      widget.cow.firstDateOfMating.add(dateText);

      await FirebaseFirestore.instance
          .collection('cows')
          .doc(widget.cow.id)
          .update({
        'firstDateOfMating': widget.cow.firstDateOfMating,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Date of Mating added successfully')));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CowDetailScreen(cowId: widget.cow.id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            Text('Add Date of Mating', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enter Date of Mating',
                  style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  hintText: 'YYYY-MM-DD',
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
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
                    return 'Please enter a date';
                  }
                  if (DateTime.tryParse(value) == null) {
                    return 'Invalid date format';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _saveDateOfMating,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
