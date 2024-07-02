import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:micro/models/feedAmount.dart';
import 'package:micro/models/milkProduction.dart';

class Cow {
  String id;
  String name;
  DateTime dateOfBirth;
  List<DateTime> dateOfGiveBirth;
  List<String> firstDateOfMating;
  List<MilkProductionEntry> milkProduction;
  List<FeedAmount> feedAmount;

  Cow({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.firstDateOfMating,
    required this.milkProduction,
    required this.dateOfGiveBirth,
    required this.feedAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'firstDateOfMating': firstDateOfMating,
      'milkProduction': milkProduction.map((entry) => entry.toMap()).toList(),
      'dateOfGiveBirth':
          dateOfGiveBirth.map((date) => date.toIso8601String()).toList(),
      'feedAmount': feedAmount.map((entry) => entry.toMap()).toList(),
    };
  }

  static Cow fromMap(Map<String, dynamic> map) {
    return Cow(
      id: map['id'],
      name: map['name'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      dateOfGiveBirth: (map['dateOfGiveBirth'] as List<dynamic>)
          .map((date) => DateTime.parse(date))
          .toList(),
      firstDateOfMating:
          (map['firstDateOfMating'] as List<dynamic>).cast<String>(),
      milkProduction: (map['milkProduction'] as List<dynamic>)
          .map((entry) => MilkProductionEntry.fromMap(entry))
          .toList(),
      feedAmount: (map['feedAmount'] as List<dynamic>)
          .map((entry) => FeedAmount.fromMap(entry))
          .toList(),
    );
  }

  static Cow fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Cow(
      id: data['id'],
      name: data['name'],
      dateOfBirth: DateTime.parse(data['dateOfBirth']),
      firstDateOfMating:
          (data['firstDateOfMating'] as List<dynamic>).cast<String>(),
      milkProduction: (data['milkProduction'] as List<dynamic>)
          .map((entry) =>
              MilkProductionEntry.fromMap(entry as Map<String, dynamic>))
          .toList(),
      dateOfGiveBirth: (data['dateOfGiveBirth'] as List<dynamic>)
          .map((date) => DateTime.parse(date))
          .toList(),
      feedAmount: (data['feedAmount'] as List<dynamic>)
          .map((entry) => FeedAmount.fromMap(entry as Map<String, dynamic>))
          .toList(),
    );
  }
}
