import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchaseproject/model/product/product_model.dart';
import 'package:purchaseproject/provider/cart/add_cart_provider.dart';
import 'package:purchaseproject/utils/app_color.dart';


class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // Calculate the total amount based on the quantity and product price
    double totalAmount = quantity * widget.product.price;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        backgroundColor: AppColors.primary,
        elevation: 6,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to the cart screen if needed
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Section with a shadow effect and rounded corners
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Image.network(
                    widget.product.images.first,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Product Title and Price with modern styling
              Text(
                widget.product.title,
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '\$${widget.product.price}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),

              // Quantity Selector with more stylish buttons
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: AppColors.primary),
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                          ),
                          Text(
                            '$quantity',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: AppColors.primary),
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Add to Cart
                          await cartProvider.addItemToCart(widget.product, quantity);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${widget.product.title} added to cart')),
                          );
                        },
                        child: Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Display the Total Amount
              Text(
                'Total: \$${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: 20),

              // Remove from Cart Button with a modern style
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Remove from Cart
                      await cartProvider.removeItemFromCart(widget.product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${widget.product.title} removed from cart')),
                      );
                    },
                    child: Text('Remove from Cart'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: AppColors.darkBlue,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Buy Now Button with a standout color
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement Buy Now action, such as navigating to the checkout screen
                    },
                    child: Text('Buy Now'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
