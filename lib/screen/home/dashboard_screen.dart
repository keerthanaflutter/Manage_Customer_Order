

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchaseproject/provider/auth_provider.dart';
import 'package:purchaseproject/provider/cart/add_cart_provider.dart';
import 'package:purchaseproject/screen/auth/login_screen.dart';
import 'package:purchaseproject/screen/home/home_screen.dart';
import 'package:purchaseproject/screen/home/product/cart_screen.dart' hide AppColors;
import 'package:purchaseproject/screen/home/product/product_list_screen.dart';
import 'package:purchaseproject/screen/home/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),  // Home Screen
    ProductListScreen(), // Categories Screen
    ProfileScreen(), // Profile Screen
   
  ];

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue,
        elevation: 0,
  
        actions: [
          // Cart icon
         _buildCartAction(cartProvider),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: AppColors.primary,
            ),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          
         
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Categories",  // New "Categories" tab
          ),
         
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          
        ],
      ),
    );
  }

   // --- Widget: AppBar Cart Action ---
  Widget _buildCartAction(CartProvider cartProvider) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.shopping_cart, color: AppColors.primary),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartScreen())),
        ),
        if (cartProvider.cartItems.isNotEmpty)
          Positioned(
            right: 8,
            top: 8,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: Text(
                '${cartProvider.cartItems.length}',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }
  
}



class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(child: Text("My Orders Screen")),
    );
  }
}
