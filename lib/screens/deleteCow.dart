import 'package:flutter/material.dart';
import 'package:micro/screens/addCow.dart';
import 'package:micro/screens/home.dart';
import 'package:micro/widgets/cowList.dart';
import 'package:micro/widgets/deleteCowList.dart';
import 'package:micro/widgets/drawer.dart';

class DeleteCowScreen extends StatelessWidget {
  const DeleteCowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delete Screen',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: DeleteCowListScreen(),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Text('Return To Home'),
            ),
          ],
        ),
      ),
    );
  }
}
