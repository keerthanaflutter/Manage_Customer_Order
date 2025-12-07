import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:purchaseproject/model/order_model.dart';

class FilterService {
  final _db = FirebaseFirestore.instance.collection("orders");

 Future<List<OrderModel>> getFilteredOrders({
  String? status,
  double? minAmount,
  double? maxAmount,
  DateTime? startDate,
  DateTime? endDate, String? sortType,
}) async {

  Query query = _db;

  if (status != null && status.isNotEmpty) {
    query = query.where('status', isEqualTo: status);
  }

  if (minAmount != null && maxAmount != null) {
    query = query
        .where('totalAmount', isGreaterThanOrEqualTo: minAmount)
        .where('totalAmount', isLessThanOrEqualTo: maxAmount)
        .orderBy('totalAmount');
  }

  
  if (startDate != null && endDate != null) {
    final start = Timestamp.fromDate(startDate);

    final end = Timestamp.fromDate(
      DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
      ),
    );

    query = query
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: end)
        .orderBy('createdAt', descending: true);
  }

  final snapshot = await query.get();

  return snapshot.docs.map((doc) {
    return OrderModel.fromMap(
      doc.id,
      doc.data() as Map<String, dynamic>,
    );
  }).toList();
}

}
