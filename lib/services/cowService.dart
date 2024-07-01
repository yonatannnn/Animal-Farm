import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:micro/models/cowModel.dart';

class CowService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'cows';

  Future<void> saveCow(Cow cow) async {
    try {
      await _firestore.collection(collectionName).doc(cow.id).set(cow.toMap());
    } catch (e) {
      print('Error saving cow: $e');
    }
  }

  Future<List<Cow>> fetchCows() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(collectionName).get();
      return querySnapshot.docs.map((doc) => Cow.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching cows: $e');
      return [];
    }
  }
}
