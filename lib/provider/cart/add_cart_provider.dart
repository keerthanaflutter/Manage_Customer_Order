import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseproject/model/cart/cart_get_model.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // This will be updated by AuthProvider via ProxyProvider
  String? _uid; 

  List<Map<String, dynamic>> get cartItems => _cartItems;

  // 1. This method receives the UID from AuthProvider
  void updateUid(String? uid) {
    if (_uid != uid) {
      _uid = uid;
      if (_uid != null) {
        fetchCartFromFirebase(); // Automatically load cart when user logs in
      } else {
        _cartItems = []; // Clear cart when user logs out
        notifyListeners();
      }
    }
  }

  // 2. Fetch existing cart from Firestore
  Future<void> fetchCartFromFirebase() async {
    if (_uid == null) return;
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_uid)
          .collection('cart')
          .get();

      _cartItems = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'product': data, // Note: You might need to map this back to your Product model
          'quantity': data['quantity'] ?? 1,
        };
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching cart: $e");
    }
  }

  double get totalAmount {
    double total = 0.0;
    for (var item in _cartItems) {
      // Assuming item['product'] has a price field
      total += (item['product']['price'] * item['quantity']);
    }
    return total;
  }

  Future<void> addItemToCart(dynamic product, int quantity) async {
    if (_uid == null) {
      print("User not logged in");
      return;
    }

    int index = _cartItems.indexWhere((item) => item['product']['productId'] == product.id);
    
    if (index != -1) {
      _cartItems[index]['quantity'] += quantity;
    } else {
      _cartItems.add({
        'product': {
          'productId': product.id,
          'title': product.title,
          'price': product.price,
          'image': product.images.first,
          'category': product.category.name,
        }, 
        'quantity': quantity
      });
    }
    notifyListeners();

    try {
      await _firestore
          .collection('users')
          .doc(_uid) // Using the dynamic UID
          .collection('cart')
          .doc(product.id.toString())
          .set({
        'productId': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.images.first,
        'quantity': index != -1 ? _cartItems[index]['quantity'] : quantity,
        'category': product.category.name,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error saving to Firebase: $e");
    }
  }

  Future<void> removeItemFromCart(dynamic product) async {
    if (_uid == null) return;

    _cartItems.removeWhere((item) => item['product']['productId'] == product.id);
    notifyListeners();

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('cart')
        .doc(product.id.toString())
        .delete();
  }

  Future<void> updateItemQuantity(dynamic product, int quantity) async {
    if (_uid == null) return;

    int index = _cartItems.indexWhere((item) => item['product']['productId'] == product.id);
    if (index != -1) {
      _cartItems[index]['quantity'] = quantity;
      notifyListeners();

      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('cart')
          .doc(product.id.toString())
          .update({'quantity': quantity});
    }
  }
}





class CartgetProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<CartItem>> get currentCartStream {
    String? uid = _auth.currentUser?.uid ?? "pnTDp9a2hka7zEGKgnslmxc3gaj1";

    return _db
        .collection('users')
        .doc(uid)
        .collection('cart')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CartItem.fromFirestore(doc.data()))
            .toList());
  }

  // Method to update quantity in Firestore
  Future<void> updateQuantity(String productId, int newQuantity) async {
    String? uid = _auth.currentUser?.uid ?? "pnTDp9a2hka7zEGKgnslmxc3gaj1";
    
    // Reference to the specific cart document
    // Note: We use productId as the document ID based on your screenshot
    DocumentReference docRef = _db
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(productId);

    if (newQuantity > 0) {
      await docRef.update({'quantity': newQuantity});
    } else {
      // If quantity is 0, remove the item from cart
      await docRef.delete();
    }
  }
}


// class CartProvider with ChangeNotifier {
//   List<Map<String, dynamic>> _cartItems = [];

//   List<Map<String, dynamic>> get cartItems => _cartItems;

//   void addItemToCart(Product product, int quantity) {
//     // Check if the product is already in the cart
//     int index = _cartItems.indexWhere((item) => item['product'] == product);
//     if (index != -1) {
//       // Update the quantity if already in cart
//       _cartItems[index]['quantity'] += quantity;
//     } else {
//       // Add new product to cart
//       _cartItems.add({
//         'product': product,
//         'quantity': quantity,
//       });
//     }
//     notifyListeners();
//   }

//   void removeItemFromCart(Product product) {
//     _cartItems.removeWhere((item) => item['product'] == product);
//     notifyListeners();
//   }

//   void updateItemQuantity(Product product, int quantity) {
//     int index = _cartItems.indexWhere((item) => item['product'] == product);
//     if (index != -1) {
//       _cartItems[index]['quantity'] = quantity;
//     }
//     notifyListeners();
//   }
// }
