import 'package:cloud_firestore/cloud_firestore.dart';

class MealModel {
  String? id;
  String uid;
  String food;
  int calories;
  String type;
  String date;
  DateTime logDateTime;

  static final String _collection = 'meals';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MealModel(
      {this.id,
      required this.uid,
      required this.food,
      required this.calories,
      required this.type,
      required this.date,
      DateTime? logDateTime})
      : logDateTime = logDateTime ?? DateTime.now();

  // Convert a Meal into a Map. The keys must correspond to the foods of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'food': food,
      'calories': calories,
      'type': type,
      'date': date,
      'logDateTime': logDateTime.toIso8601String(),
    };
  }

  // Extract a Meal object from a Map object
  static MealModel fromMap(Map<String, dynamic> map) {
    return MealModel(
      id: map['id'],
      uid: map['uid'],
      food: map['food'],
      calories: map['calories'],
      type: map['type'],
      date: map['date'],
      logDateTime: DateTime.parse(map['logDateTime']),
    );
  }

  Future<void> addToFirestore() async {
    DocumentReference docRef =
        await _firestore.collection(_collection).add(toMap());
    id = docRef.id; // Assign the generated document ID to the model's id
    // Optionally, update the document with the id if needed
    await docRef.update({'id': this.id});
  }

  static Future<MealModel?> fetchFromFirestore(String documentId) async {
    DocumentSnapshot doc =
        await _firestore.collection(_collection).doc(documentId).get();
    if (doc.exists) {
      return MealModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateInFirestore(String documentId) async {
    await _firestore.collection(_collection).doc(documentId).update(toMap());
  }

  static Future<void> deleteFromFirestore(String documentId) async {
    await _firestore.collection(_collection).doc(documentId).delete();
  }

  static Future<List<MealModel>> fetchMealsForUser(String uid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collection)
          .where('uid', isEqualTo: uid)
          .orderBy('logDateTime', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => MealModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    }
    // The order by requires an index, so if the index is not created, the query
    // will fail. In this case, we can fetch the data without the order by.
    catch (e) {
      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection(_collection)
            .where('uid', isEqualTo: uid)
            .get();
        return querySnapshot.docs
            .map((doc) => MealModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      }
      // If the query still fails, return an empty list
      catch (e) {
        return List.empty();
      }
    }
  }

  static Future<void> deleteMealsForUser(String uid) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(_collection)
        .where('uid', isEqualTo: uid)
        .get();
    querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  }

  static Future<List<MealModel>> searchMealsForUserOfDay(
      String uid, String date) async {
    // Search for meals of the current date and order them by logDateTime
    // order by can fail if the index is not created in Firestore
    // In this case, we can fetch the data without the order by
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collection)
          .where('uid', isEqualTo: uid)
          .where('date', isEqualTo: date)
          .orderBy('logDateTime', descending: true)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return List.empty();
      }
      return querySnapshot.docs
          .map((doc) => MealModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection(_collection)
            .where('uid', isEqualTo: uid)
            .where('date', isEqualTo: date)
            .get();
        if (querySnapshot.docs.isEmpty) {
          return List.empty();
        }
        return querySnapshot.docs
            .map((doc) => MealModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      } catch (e) {
        return List.empty();
      }
    }
  }
}
