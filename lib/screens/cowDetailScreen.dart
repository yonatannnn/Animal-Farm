import 'package:flutter/material.dart';
import 'package:micro/models/cowModel.dart';
import 'package:micro/models/feedAmount.dart';
import 'package:micro/models/milkProduction.dart';
import 'package:micro/screens/addDateOGiveBirth.dart';
import 'package:micro/screens/addDateOfMatingScreen.dart';
import 'package:micro/screens/addFeedAmount.dart';
import 'package:micro/screens/addMilkProductionScreen.dart';
import 'package:micro/screens/editCowScreen.dart';
import 'package:micro/services/cowService.dart';

class CowDetailScreen extends StatefulWidget {
  final String cowId;

  CowDetailScreen({required this.cowId});

  @override
  State<CowDetailScreen> createState() => _CowDetailScreenState();
}

class _CowDetailScreenState extends State<CowDetailScreen> {
  CowService _cowService = CowService();
  Cow? cow;
  List<String> firstDateOfGiveBirths = [];
  List<String> firstDateOfMating = [];
  List<Map<String, dynamic>> milks = [];
  List<FeedAmount> feeds = [];
  Map<String, List<double>> F = {};

  @override
  void initState() {
    super.initState();
    _fetchCowDetails();
  }

  Future<void> _fetchCowDetails() async {
    try {
      Cow fetchedCow = await _cowService.fetchCowById(widget.cowId);

      setState(() {
        cow = fetchedCow;
        firstDateOfGiveBirths = cow!.dateOfGiveBirth
            .map((date) => date.toString().split(' ')[0])
            .toList();
        milks = cow!.milkProduction.map((milk) => milk.toMap()).toList();
        F.clear();
        for (FeedAmount f in cow!.feedAmount) {
          String ingredientKey = f.ingredient.toLowerCase();

          if (F.containsKey(ingredientKey)) {
            F[ingredientKey]!.add(f.amount);
          } else {
            F[ingredientKey] = [f.amount];
          }
        }
      });
    } catch (e) {
      print('Error fetching cow details: $e');
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to fetch cow details. Please try again later.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  List<List<double>> getWeeklyMilkData() {
    if (cow == null) return [];
    List<MilkProductionEntry> milkEntries = cow!.milkProduction;
    milkEntries.sort((a, b) => a.date.compareTo(b.date));
    List<List<double>> weeklyData = [];
    List<double> currentWeek = [];
    for (var entry in milkEntries) {
      currentWeek.add(entry.amount);
      if (currentWeek.length == 7) {
        double s = currentWeek.reduce((a, b) => a + b);
        currentWeek.add(s);
        weeklyData.add(currentWeek);
        currentWeek = [];
      }
    }

    if (currentWeek.any((amount) => amount > 0)) {
      currentWeek.add(currentWeek.reduce((a, b) => a + b));
      weeklyData.add(currentWeek);
    }

    return weeklyData;
  }

  @override
  Widget build(BuildContext context) {
    List<List<double>> weeklyMilkData = getWeeklyMilkData();

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
                  builder: (context) => EditCowScreen(cow: cow!),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildDetailRow('Name', cow?.name ?? ''),
              _buildDetailRow('Date of Birth',
                  cow?.dateOfBirth.toLocal().toString().split(' ')[0] ?? ''),
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
                children: (cow?.firstDateOfMating ?? [])
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
                children: (cow?.dateOfGiveBirth ?? [])
                    .map((date) =>
                        _buildDetailRow('Date', date.toString().split(' ')[0]))
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
              SizedBox(height: 20),
              _buildMilkProductionTable(weeklyMilkData),
              SizedBox(height: 20),
              _buildFeedAmountList(),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddMilkProductionScreen(cow: cow!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 255, 255, 255),
                      backgroundColor: Color.fromARGB(255, 63, 54, 139),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text('Add Milk Production'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddFeedAmountScreen(cow: cow!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 255, 255, 255),
                      backgroundColor: Color.fromARGB(255, 63, 54, 139),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text('Add feed Amount'),
                  ),
                ]),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddDateOfMatingScreen(cow: cow!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 255, 255, 255),
                      backgroundColor: Color.fromARGB(255, 63, 54, 139),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text('Add Date of Mating'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddDateOfGiveBirthScreen(cow: cow!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 255, 255, 255),
                      backgroundColor: Color.fromARGB(255, 63, 54, 139),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text('Add Date Of Give Birth'),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMilkProductionTable(List<List<double>> weeklyMilkData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: weeklyMilkData.map((weekData) {
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Week ${weeklyMilkData.indexOf(weekData) + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (int i = 0; i < weekData.length; i++)
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Text(
                          '${weekData[i]}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeedAmountList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Feed Amount',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: F.keys.length,
            itemBuilder: (context, index) {
              String ingredient = F.keys.elementAt(index);
              List<double> amounts = F[ingredient] ?? [];
              String Ingredient =
                  ingredient[0].toUpperCase() + ingredient.substring(1);
              return ListTile(
                title: Text(
                  Ingredient,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${amounts.join(" + ")} = ${amounts.reduce((a, b) => a + b)} Kg',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                dense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        ),
      ],
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
