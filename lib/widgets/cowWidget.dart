import 'package:flutter/material.dart';
import 'package:micro/models/cowModel.dart'; // Import your Cow model

class SingleCow extends StatelessWidget {
  final Cow cow;
  final int index;

  SingleCow({
    Key? key,
    required this.cow,
    required this.index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDateOfBirth = _formatDate(cow.dateOfBirth);
    List<String> formattedDatesOfGiveBirth =
        cow.dateOfGiveBirth.map((date) => _formatDate(date)).toList();

    return Card(
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Text('$index' ,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        title: Text(
          cow.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date of Birth: $formattedDateOfBirth'),
            Text('First Date of Mating: ${cow.firstDateOfMating}'),
            Text(
                'Dates of Give Birth: ${formattedDatesOfGiveBirth.join(", ")}'),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
