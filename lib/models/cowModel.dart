import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:micro/models/milkProduction.dart';

class Cow {
  String id;
  String name;
  DateTime dateOfBirth;
  List<DateTime> dateOfGiveBirth;
  String firstDateOfMating;
  List<MilkProductionEntry> milkProduction;

  Cow({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.firstDateOfMating,
    required this.milkProduction,
    required this.dateOfGiveBirth,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'firstDateOfMating': firstDateOfMating,
      'milkProduction': milkProduction.map((entry) => entry.toMap()).toList(),
      'dateOfGiveBirth': dateOfGiveBirth.map((date) => date.toIso8601String()).toList(),
    };
  }

  static Cow fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Cow(
      id: data['id'],
      name: data['name'],
      dateOfBirth: DateTime.parse(data['dateOfBirth']),
      firstDateOfMating: data['firstDateOfMating'],
      milkProduction: (data['milkProduction'] as List<dynamic>)
          .map((entry) => MilkProductionEntry.fromMap(entry as Map<String, dynamic>))
          .toList(),
      dateOfGiveBirth: (data['dateOfGiveBirth'] as List<dynamic>)
          .map((date) => DateTime.parse(date))
          .toList(),
    );
  }
}
