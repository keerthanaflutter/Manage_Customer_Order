class CartItem {
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String image;

  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory CartItem.fromFirestore(Map<String, dynamic> data) {
    return CartItem(
      // Matching the fields from your screenshot
      productId: (data['productId'] ?? '').toString(),
      title: data['title'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 0,
      image: data['image'] ?? '',
    );
  }
}