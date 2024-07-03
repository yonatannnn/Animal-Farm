import 'package:flutter/material.dart';
import 'package:micro/models/cowModel.dart';
import 'package:micro/models/feedAmount.dart';
import 'package:micro/screens/editFeedAmountScreen.dart';
import 'package:micro/services/cowService.dart';
import 'package:micro/widgets/drawer.dart';

class DetailFeedAmountScreen extends StatefulWidget {
  Cow coww;
  DetailFeedAmountScreen({required this.coww});

  @override
  State<DetailFeedAmountScreen> createState() => _DetailFeedAmountScreenState();
}

class _DetailFeedAmountScreenState extends State<DetailFeedAmountScreen> {
  CowService _cowService = CowService();
  Cow? cow;
  List<Map<String, dynamic>> feeds = [];

  @override
  void initState() {
    super.initState();
    _fetchCowDetails();
  }

  Future<void> _fetchCowDetails() async {
    try {
      Cow fetchedCow = await _cowService.fetchCowById(widget.coww!.id);

      setState(() {
        cow = fetchedCow;
        feeds = cow!.feedAmount.map((milk) => milk.toMap()).toList();
      });
      print(feeds);
    } catch (e) {
      print('Error fetching cow details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Feed Amount Detail', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      drawer: CustomDrawer(),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(width: 10), color: Colors.white),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  if (index < feeds.length) {
                    return Row(
                      children: [
                        Text(
                          '${feeds[index]['ingredient']}    ->    ${feeds[index]['amount']} KG',
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
                                  EditFeedAmountScreen(cow: cow!),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 255, 255, 255),
                          backgroundColor: Color.fromARGB(255, 63, 54, 139),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        child: Text('Edit Milk Production'),
                      ),
                    );
                  }
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: feeds.length + 1)),
      ),
    );
  }
}
