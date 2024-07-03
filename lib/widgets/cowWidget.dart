import 'package:flutter/material.dart';
import 'package:micro/models/cowModel.dart';
import 'package:micro/screens/cowDetailScreen.dart'; // Import your Cow model

class SingleCow extends StatelessWidget {
  final Cow cow;
  final int index;

  SingleCow({Key? key, required this.cow, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDateOfBirth = _formatDate(cow.dateOfBirth);
    List<String> formattedDatesOfGiveBirth =
        cow.dateOfGiveBirth.map((date) => _formatDate(date)).toList();

    return Container(
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date of Birth: $formattedDateOfBirth',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CowDetailScreen(cowId: cow.id),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
