import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:purchaseproject/model/order_model.dart';

class OrderService {
  final _db = FirebaseFirestore.instance;

  // 🔹 Fetch Orders (REAL-TIME)
  Stream<List<OrderModel>> getOrders() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }



 Future<bool> updateStatus(String docId, String newStatus) async {
    try {
      await _db.collection('orders').doc(docId).update({
        'status': newStatus,
      });
      return true;
    } on FirebaseException catch (e) {
      debugPrint('Firestore updateStatus error: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Unknown updateStatus error: $e');
      return false;
    }
  }


  Future<void> deleteOrder(String docId) async {
  await _db.collection('orders').doc(docId).delete();
}


}
