import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchaseproject/provider/cart/add_cart_provider.dart';
import 'package:purchaseproject/provider/product/product_list_provider.dart' show ProductProvider;
import 'package:purchaseproject/screen/home/product/cart_screen.dart';
import 'package:purchaseproject/screen/home/product/product_detail_screen.dart';
import 'package:shimmer/shimmer.dart'; // Import Shimmer package for loading effect


class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _isLoading = true;
  int? _selectedCategoryId; // Tracks the selected category filter

  @override
  void initState() {
    super.initState();
    // Fetch product data
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });

    // Simulate loading time for shimmer
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    // 1. Get unique categories from the product list
    final categories = <int, String>{};
    for (var product in productProvider.products) {
      categories[product.category.id] = product.category.name;
    }

    // Optional: Auto-select the first category if none is selected and categories are available
    if (_selectedCategoryId == null && categories.isNotEmpty) {
      _selectedCategoryId = categories.keys.first;
    }

    // 2. Filter products based on selected category
    final displayedProducts = _selectedCategoryId == null
        ? productProvider.products
        : productProvider.products
            .where((p) => p.category.id == _selectedCategoryId)
            .toList();

    return Scaffold(
      body: SingleChildScrollView(  // Make the body scrollable
        child: Column(
          children: [
            // --- Category Selection Bar ---
            if (!_isLoading) _buildCategoryBar(categories),

            // --- Product List or Shimmer ---
            Padding(  // Added padding to separate the product list from category bar
              padding: const EdgeInsets.only(top: 10.0),
              child: _isLoading
                  ? _buildShimmerLoading()
                  : _buildProductList(displayedProducts, cartProvider),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget: Horizontal Category Selector ---
  Widget _buildCategoryBar(Map<int, String> categories) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.8), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: categories.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: _selectedCategoryId == entry.key,
              selectedColor: Colors.white,
              labelStyle: TextStyle(
                color: _selectedCategoryId == entry.key
                    ? AppColors.primary
                    : Colors.grey,
              ),
              onSelected: (selected) {
                setState(() {
                  if (selected) _selectedCategoryId = entry.key;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Widget: The Main Product List (using ListView) ---
  Widget _buildProductList(List<dynamic> products, CartProvider cart) {
    if (products.isEmpty) {
      return Center(child: Text("No products found in this category."));
    }

    return ListView.builder(
      shrinkWrap: true,  // Ensures the list takes up only the necessary space
      physics: NeverScrollableScrollPhysics(),  // Disables scroll for nested ListView
      padding: EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          elevation: 8,
          shadowColor: AppColors.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(  // Added InkWell for tap action
            onTap: () {
              // Navigate to ProductDetailScreen when a product is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Image section
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.images.first,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image, size: 120),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Product details section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '\$${product.price}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add to cart button
                  IconButton(
                    icon: Icon(Icons.add_shopping_cart, color: AppColors.primary),
                    onPressed: () {
                      cart.addItemToCart(product, 1);  // Add product to cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.title} added to cart!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Widget: Shimmer Effect ---
  Widget _buildShimmerLoading() {
    return ListView.builder(
      shrinkWrap: true,  // Ensures the list takes up only the necessary space
      physics: NeverScrollableScrollPhysics(),  // Disables scroll for nested ListView
      padding: EdgeInsets.all(10),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 8,
            shadowColor: Colors.grey[400]!,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Container(width: 120, height: 120, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 100, height: 15, color: Colors.white),
                      SizedBox(height: 4),
                      Container(width: 80, height: 12, color: Colors.white),
                      SizedBox(height: 4),
                      Container(width: 120, height: 12, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
