import 'package:flutter/material.dart';
import 'package:micro/models/cowModel.dart';
import 'package:micro/models/milkProduction.dart';
import 'package:micro/screens/addMilkProductionScreen.dart';
import 'package:micro/screens/editCowScreen.dart';

class CowDetailScreen extends StatefulWidget {
  final Cow cow;

  CowDetailScreen({required this.cow});

  @override
  State<CowDetailScreen> createState() => _CowDetailScreenState();
}

class _CowDetailScreenState extends State<CowDetailScreen> {
  List<String> firstDateOfGiveBirths = [];
  List<String> firstDateOfMating = [];
  List<Map<String, dynamic>> milks = [];

  @override
  void initState() {
    firstDateOfGiveBirths = widget.cow.dateOfGiveBirth
        .map((date) => date.toString().split(' ')[0])
        .toList();
    milks = widget.cow.milkProduction.map((milk) => milk.toMap()).toList();
    firstDateOfMating = widget.cow.firstDateOfMating;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cow Detail', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCowScreen(cow: widget.cow),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildDetailRow('Name', widget.cow.name),
            _buildDetailRow('Date of Birth',
                widget.cow.dateOfBirth.toLocal().toString().split(' ')[0]),
            SizedBox(height: 20),
            Text(
              'Dates of Mating',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: firstDateOfMating
                  .map((date) => _buildDetailRow('Date', date))
                  .toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Dates of Give Birth',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: firstDateOfGiveBirths
                  .map((date) => _buildDetailRow('Date', date))
                  .toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Milk Production',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddMilkProductionScreen(cow: widget.cow),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Color.fromARGB(255, 255, 255, 255),
                backgroundColor: Color.fromARGB(255, 63, 54, 139),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text('Add Milk Production'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
