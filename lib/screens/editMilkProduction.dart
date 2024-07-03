import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:micro/models/cowModel.dart';
import 'package:micro/models/milkProduction.dart';
import 'package:micro/screens/detailMilkProductionScreen.dart';
import 'package:micro/services/cowService.dart';
import 'package:micro/widgets/drawer.dart';

class EditMilkProductionScreen extends StatefulWidget {
  final Cow cow;

  EditMilkProductionScreen({required this.cow});

  @override
  _EditMilkProductionScreenState createState() =>
      _EditMilkProductionScreenState();
}

class _EditMilkProductionScreenState extends State<EditMilkProductionScreen> {
  late List<MilkProductionEntry> _milkProduction;

  @override
  void initState() {
    super.initState();
    _milkProduction = widget.cow.milkProduction;
  }

  void _updateMilkProduction(int index, double amount) {
    setState(() {
      _milkProduction[index] = MilkProductionEntry(
        date: _milkProduction[index].date,
        amount: amount,
      );
    });
  }

  void _deleteMilkProduction(int index) {
    setState(() {
      _milkProduction.removeAt(index);
    });
  }

  Future<void> _saveChanges() async {
    widget.cow.milkProduction = _milkProduction;
    try {
      await CowService().updateCow(widget.cow);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailMilkProductionScreen(coww: widget.cow)));
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Edit Milk Production', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      drawer: CustomDrawer(),
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: ListView.builder(
          itemCount: _milkProduction.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Text(
                  _milkProduction[index].date.toIso8601String().split('T')[0],
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    initialValue: _milkProduction[index].amount.toString(),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Amount',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(137, 255, 255, 255),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    onChanged: (value) {
                      double? amount = double.tryParse(value);
                      if (amount != null) {
                        _updateMilkProduction(index, amount);
                      }
                    },
                  ),
                ),
                SizedBox(width: 15),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteMilkProduction(index);
                  },
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveChanges,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        child: Text('Save',
            style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
