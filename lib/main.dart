
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchaseproject/provider/auth_provider.dart';
import 'package:purchaseproject/provider/cart/add_cart_provider.dart';
import 'package:purchaseproject/provider/home/productFilter_provider.dart';
import 'package:purchaseproject/provider/home/productListget_provider.dart';
import 'package:purchaseproject/provider/product/product_list_provider.dart';
import 'package:purchaseproject/screen/auth/login_screen.dart';
import 'package:purchaseproject/screen/home/dashboard_screen.dart';


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Import your providers and screens here
// import 'auth_provider.dart';
// import 'cart_provider.dart';
// ... other imports

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. AuthProvider: The "Source of Truth" for User ID
        // We trigger checkLoginStatus immediately using the cascade operator (..)
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..checkLoginStatus(),
        ),

        // 2. Independent Providers
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartgetProvider()),

        // 3. Dependent Provider: CartProvider
        // It listens to AuthProvider to get the Firebase Document ID (UID)
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (context, auth, cart) {
            // This method in CartProvider updates the UID and fetches data if logged in
            return cart!..updateUid(auth.user?.uid);
          },
        ),
      ],
      child: const AppRouter(),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        // Show a loading screen while checking if the user is logged in
        if (!auth.isInitialized) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shopping App',
          // Theme data can be added here
          theme: ThemeData(primarySwatch: Colors.blue),
          // Route logic based on login status
          home: auth.isLoggedIn 
              ? const HomeScreen() 
              : const LoginScreen(),
        );
      },
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => OrderProvider()),
//         ChangeNotifierProvider(create: (_) => FilterProvider()),
//         ChangeNotifierProvider(create: (_) => ProductProvider()),
//         ChangeNotifierProvider(create: (context) => CartProvider()),
//       ],
//       child: RootApp(),
//     ),
//   );
// }



// class RootApp extends StatelessWidget {
//   const RootApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }


// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();

//     Future.microtask(() {
//       context.read<AuthProvider>().checkLoginStatus();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, auth, _) {
//         if (!auth.isInitialized) {
//           return const MaterialApp(
//             home: Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             ),
//           );
//         }

//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           home: auth.isLoggedIn
//               ? const HomeScreen()
//               : LoginScreen(),
//         );
//       },
//     );
//   }
// }