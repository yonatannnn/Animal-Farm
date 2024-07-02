import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:micro/models/cowModel.dart';
import 'package:micro/models/feedAmount.dart';
import 'package:micro/screens/cowDetailScreen.dart';

class AddFeedAmountScreen extends StatefulWidget {
  final Cow cow;

  AddFeedAmountScreen({required this.cow});

  @override
  _AddFeedAmountScreenState createState() => _AddFeedAmountScreenState();
}

class _AddFeedAmountScreenState extends State<AddFeedAmountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ingredientController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _ingredientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveFeedAmount() async {
    if (_formKey.currentState!.validate()) {
      FeedAmount feed = FeedAmount(
        ingredient: _ingredientController.text,
        amount: double.parse(_amountController.text),
      );

      widget.cow.feedAmount.add(feed);

      await FirebaseFirestore.instance
          .collection('cows')
          .doc(widget.cow.id)
          .update({
        'feedAmount': widget.cow.feedAmount.map((e) => e.toMap()).toList(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feed Amount added successfully')));

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CowDetailScreen(cowId: widget.cow.id)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Add Feed Amount',
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
                    'Add Feed Amount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    _ingredientController,
                    'Ingredient',
                    'Enter ingredient name',
                    TextInputType.text,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    _amountController,
                    'Amount (kg)',
                    'Enter amount in kilograms',
                    TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveFeedAmount,
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
      String validationMessage, TextInputType keyboardType) {
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
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }
}
