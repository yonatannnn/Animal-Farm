import 'package:flutter/material.dart';
import 'package:micro/models/cowModel.dart';
import 'package:micro/screens/editMilkProduction.dart';
import 'package:micro/services/cowService.dart';
import 'package:micro/widgets/drawer.dart';

class DetailMilkProductionScreen extends StatefulWidget {
  Cow coww;
  DetailMilkProductionScreen({required this.coww});

  @override
  State<DetailMilkProductionScreen> createState() =>
      _DetailMilkProductionScreenState();
}

class _DetailMilkProductionScreenState
    extends State<DetailMilkProductionScreen> {
  CowService _cowService = CowService();
  Cow? cow;
  List<Map<String, dynamic>> milks = [];

  @override
  void initState() {
    super.initState();
    _fetchCowDetails();
  }

  Future<void> _fetchCowDetails() async {
    try {
      Cow fetchedCow = await _cowService.fetchCowById(widget.coww.id);

      setState(() {
        cow = fetchedCow;
        milks = cow!.milkProduction.map((milk) => milk.toMap()).toList();
      });
      print(milks);
    } catch (e) {
      print('Error fetching cow details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Milk Production Detail',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(),
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration:
              BoxDecoration(border: Border.all(width: 10), color: Colors.white),
          child: ListView.separated(
            itemBuilder: (context, index) {
              if (index < milks.length) {
                return Row(
                  children: [
                    Text(
                      '${milks[index]['date'].toString().split('T')[0]}    ->    ${milks[index]['amount']} Litre',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                );
              } else {
                return Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditMilkProductionScreen(cow: cow!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 255, 255, 255),
                      backgroundColor: Color.fromARGB(255, 63, 54, 139),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text('Edit Milk Production'),
                  ),
                );
              }
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: milks.length + 1,
          ),
        ),
      ),
    );
  }
}
