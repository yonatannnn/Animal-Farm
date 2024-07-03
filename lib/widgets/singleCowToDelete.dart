import 'package:flutter/material.dart';
import 'package:micro/models/cowModel.dart';
import 'package:micro/screens/cowDetailScreen.dart';
import 'package:micro/services/cowService.dart';

class SingleCowToDetle extends StatelessWidget {
  final Cow cow;
  final int index;

  SingleCowToDetle({Key? key, required this.cow, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDateOfBirth = _formatDate(cow.dateOfBirth);
    List<String> formattedDatesOfGiveBirth =
        cow.dateOfGiveBirth.map((date) => _formatDate(date)).toList();

    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        color: Colors.white.withOpacity(0),
        elevation: 6,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/cow2.png'),
            radius: 30,
          ),
          title: Text(
            cow.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {},
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              _showDeleteConfirmation(context);
            },
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Cow'),
          content: Text('Are you sure you want to delete ${cow.name}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCow(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteCow(BuildContext context) async {
    try {
      await CowService().deleteCow(cow.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cow deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete cow: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
