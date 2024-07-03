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

  Future<void> updateCow(Cow cow) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(cow.id)
          .update(cow.toMap());
    } catch (e) {
      print('Error updating cow: $e');
    }
  }

  Future<void> deleteCow(String cowId) async {
    try {
      await _firestore.collection(collectionName).doc(cowId).delete();
      print('Cow deleted successfully');
    } catch (e) {
      print('Error deleting cow: $e');
    }
  }

  Future<List<Cow>> fetchCows() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collectionName).get();
      return querySnapshot.docs.map((doc) => Cow.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching cows: $e');
      return [];
    }
  }

  Future<Cow> fetchCowById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collectionName).doc(id).get();
      return Cow.fromFirestore(doc);
    } catch (e) {
      print('Error fetching cow: $e');
      throw e;
    }
  }

  Stream<Cow?> streamCowById(String cowId) {
    return _firestore.collection('cows').doc(cowId).snapshots().map(
        (snapshot) => snapshot.exists ? Cow.fromMap(snapshot.data()!) : null);
  }

  Stream<List<Cow>> getCowsStream() {
    return _firestore.collection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Cow.fromFirestore(doc)).toList();
    });
  }
}
