import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:purchaseproject/model/product/product_model.dart';

// class ProductProvider with ChangeNotifier {
//   List<Product> _products = [];
//   bool _isLoading = false;

//   List<Product> get products => _products;
//   bool get isLoading => _isLoading;

//   Future<void> fetchProducts() async {
//     _isLoading = true;
//     notifyListeners();
//     final response = await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products'));

//     if (response.statusCode == 200) {
//       final List<dynamic> productList = json.decode(response.body);
//       _products = productList.map((json) => Product.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load products');
//     }

//     _isLoading = false;
//     notifyListeners();
//   }
// }


class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    
    // Print debug message before making the API call
    print("Fetching products from the API...");

    try {
      final response = await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products'));

      // Print the raw response data in the terminal
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> productList = json.decode(response.body);
        
        // Print the decoded product list to verify the data structure
        print("Decoded product list: $productList");

        _products = productList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      // Catch any exceptions and print the error message
      print("Error occurred while fetching products: $error");
    }

    _isLoading = false;
    notifyListeners();
  }
}
