import 'package:flutter/material.dart';
import 'package:micro/screens/about.dart';
import 'package:micro/screens/deleteCow.dart';
import 'package:micro/screens/home.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: Color.fromARGB(255, 0, 0, 0),
            padding: EdgeInsets.all(30),
            child: DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/cb.png'),
                  fit: BoxFit.scaleDown,
                ),
              ),
              child: null,
            ),
          ),
          SizedBox(height: 10),
          Container(
            color: Colors.grey.withOpacity(0.4),
            child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Text('Home',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18))),
          ),
          Divider(),
          Container(
            color: Colors.grey.withOpacity(0.4),
            child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutPage()));
                },
                child: Text('About Page',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18))),
          ),
          Divider(),
          Container(
            color: Colors.grey.withOpacity(0.4),
            child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeleteCowScreen()));
                },
                child: Text('Delete Cow',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18))),
          ),
        ],
      ),
    );
  }
}
