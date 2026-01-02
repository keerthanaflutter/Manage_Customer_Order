import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchaseproject/model/cart/cart_get_model.dart';
import 'package:purchaseproject/provider/cart/add_cart_provider.dart';
import 'package:purchaseproject/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppColors {
  static const primary = Color(0xFF0A4D8C);
  static const lightBlue = Color(0xFFEAF4FF);
  static const darkBlue = Color(0xFF083C6D);
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartgetProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: AppBar(
        title: const Text(
          "My Shopping Cart",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: cartProvider.currentCartStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Your cart is empty", style: TextStyle(color: AppColors.darkBlue)));
          }

          final cartItems = snapshot.data!;
          double totalAmount = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(item.image, width: 70, height: 70, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.darkBlue),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text("\$${item.price.toStringAsFixed(2)}", style: TextStyle(color: Colors.grey[600])),
                                  const SizedBox(height: 8),
                                  
                                  // --- QUANTITY CONTROLLER ---
                                  Row(
                                    children: [
                                      _quantityButton(
                                        icon: Icons.remove,
                                        onPressed: () => cartProvider.updateQuantity(item.productId, item.quantity - 1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text(
                                          "${item.quantity}",
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      _quantityButton(
                                        icon: Icons.add,
                                        onPressed: () => cartProvider.updateQuantity(item.productId, item.quantity + 1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Individual item total price
                            Text(
                              "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Bottom Summary Section
              _buildCheckoutSection(totalAmount),
            ],
          );
        },
      ),
    );
  }

  // Helper widget for Plus/Minus buttons
  Widget _quantityButton({required IconData icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }

  Widget _buildCheckoutSection(double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              Text("\$${total.toStringAsFixed(2)}", 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text("Proceed to Checkout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}