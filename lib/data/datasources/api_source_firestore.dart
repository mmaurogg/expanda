import 'package:cloud_firestore/cloud_firestore.dart';

class ApiSourceFirestore {
  final FirebaseFirestore _firestore;

  ApiSourceFirestore(this._firestore);

  Future<QuerySnapshot<Map<String, dynamic>>> getFirestore<T>({
    required String collection,
  }) async {
    try {
      final querySnapshot = await _firestore.collection(collection).get();

      return querySnapshot;
    } catch (e) {
      throw Exception('Error al obtener eventos: ${e.toString()}');
    }
  }

  Future<DocumentReference<Map<String, dynamic>>> addFirestore<T>({
    required String collection,
    required Map<String, dynamic> json,
  }) async {
    try {
      final querySnapshot = await _firestore.collection(collection).add(json);

      return querySnapshot;
    } catch (e) {
      throw Exception('Error al obtener eventos: ${e.toString()}');
    }
  }
}
