import 'package:flutter/material.dart';
import 'package:micro/models/cowModel.dart';
import 'package:micro/services/cowService.dart';
import 'package:micro/widgets/cowWidget.dart';

class CowListScreen extends StatelessWidget {
  final CowService _cowService = CowService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Cow>>(
      stream: _cowService.getCowsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No cows available.'));
        } else {
          List<Cow> cows = snapshot.data!;
          return ListView.builder(
            itemCount: cows.length,
            itemBuilder: (context, index) {
              return SingleCow(cow: cows[index], index: index + 1);
            },
          );
        }
      },
    );
  }
}
