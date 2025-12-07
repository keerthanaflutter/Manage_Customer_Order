class OrderModel {
  final String id;
  final String orderId;
  final String customerName;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(String docId, Map<String, dynamic> data) {
    return OrderModel(
      id: docId,
      orderId: data['orderId'] ?? '',
      customerName: data['customerName'] ?? '',
      totalAmount: (data['totalAmount'] as num).toDouble(),
      status: data['status'] ?? '',
      createdAt: data['createdAt'].toDate(),
    );
  }

  static fromJson(Map<String, dynamic> data) {}
}
