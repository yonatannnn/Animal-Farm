import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:micro/models/cowModel.dart';
import 'package:micro/models/milkProduction.dart';
import 'package:abushakir/abushakir.dart';

class AddMilkProductionScreen extends StatefulWidget {
  final Cow cow;

  AddMilkProductionScreen({required this.cow});

  @override
  _AddMilkProductionScreenState createState() =>
      _AddMilkProductionScreenState();
}

class _AddMilkProductionScreenState extends State<AddMilkProductionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  EtDatetime? _selectedEthiopianDate;
  int _selectedYear = EtDatetime.now().year;
  int _selectedMonth = EtDatetime.now().month;
  int _selectedDay = EtDatetime.now().day;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveMilkProduction() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      MilkProductionEntry entry = MilkProductionEntry(
        date: _selectedDate!,
        amount: double.parse(_amountController.text),
      );

      widget.cow.milkProduction.add(entry);

      await FirebaseFirestore.instance
          .collection('cows')
          .doc(widget.cow.id)
          .update({
        'milkProduction':
            widget.cow.milkProduction.map((e) => e.toMap()).toList()
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Milk Production added successfully')));
      Navigator.pop(context);
    }
  }

  void _updateSelectedDate() {
    setState(() {
      _selectedEthiopianDate = EtDatetime(
          year: _selectedYear, month: _selectedMonth, day: _selectedDay);
      _selectedDate =
          DateTime.fromMillisecondsSinceEpoch(_selectedEthiopianDate!.moment);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<int> years =
        List<int>.generate(50, (i) => 2000 + i); // From year 2000 to 2049
    List<int> months =
        List<int>.generate(13, (i) => i + 1); // Ethiopian months (1-13)
    List<int> days = List<int>.generate(30, (i) => i + 1); // Days (1-30)

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
                    'Add Milk Production',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(_amountController, 'Amount (liters)',
                      'Please enter an amount'),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDropdown(years, _selectedYear, 'Year',
                          (int? newValue) {
                        setState(() {
                          _selectedYear = newValue!;
                          _updateSelectedDate();
                        });
                      }),
                      SizedBox(width: 8),
                      _buildDropdown(months, _selectedMonth, 'Month',
                          (int? newValue) {
                        setState(() {
                          _selectedMonth = newValue!;
                          _updateSelectedDate();
                        });
                      }),
                      SizedBox(width: 8),
                      _buildDropdown(days, _selectedDay, 'Day',
                          (int? newValue) {
                        setState(() {
                          _selectedDay = newValue!;
                          _updateSelectedDate();
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    _selectedEthiopianDate == null
                        ? 'No date chosen!'
                        : 'Picked Date: ${_selectedEthiopianDate!.toString()}',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveMilkProduction,
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

  Widget _buildDropdown(List<int> items, int selectedValue, String hint,
      ValueChanged<int?> onChanged) {
    return DropdownButton<int>(
      value: selectedValue,
      dropdownColor: Colors.black,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            value.toString(),
            style: TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}
