import 'package:flutter/material.dart';
import 'package:micro/models/cowModel.dart';
import 'package:micro/models/feedAmount.dart';
import 'package:micro/screens/home.dart';
import 'package:micro/services/cowService.dart';
import 'package:micro/widgets/drawer.dart';

class EditFeedAmountScreen extends StatefulWidget {
  final Cow cow;

  EditFeedAmountScreen({required this.cow});

  @override
  _EditFeedAmountScreenState createState() => _EditFeedAmountScreenState();
}

class _EditFeedAmountScreenState extends State<EditFeedAmountScreen> {
  late List<FeedAmount> _feedAmounts;

  @override
  void initState() {
    super.initState();
    _feedAmounts = widget.cow.feedAmount;
  }

  void _updateFeedAmount(int index, double amount) {
    setState(() {
      _feedAmounts[index] = FeedAmount(
        ingredient: _feedAmounts[index].ingredient,
        amount: amount,
      );
    });
  }

  void _deleteFeedAmount(int index) {
    setState(() {
      _feedAmounts.removeAt(index);
    });
  }

  Future<void> _saveChanges() async {
    widget.cow.feedAmount = _feedAmounts;
    try {
      await CowService().updateCow(widget.cow);
      Navigator.pop(context, true);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Feed Amount', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 6, 33, 56),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ],
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: _feedAmounts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _feedAmounts[index].ingredient,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    initialValue: _feedAmounts[index].amount.toString(),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Amount',
                      hintStyle: TextStyle(
                          color: const Color.fromARGB(137, 255, 255, 255)),
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
                        _updateFeedAmount(index, amount);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteFeedAmount(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveChanges,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        child: Text('Save',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
      ),
    );
  }
}
