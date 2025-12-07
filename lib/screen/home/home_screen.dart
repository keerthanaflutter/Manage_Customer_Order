

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchaseproject/provider/auth_provider.dart';
import 'package:purchaseproject/screen/auth/login_screen.dart';
import 'package:purchaseproject/screen/home/orderListget_screen.dart';
import 'package:purchaseproject/screen/home/profile_screen.dart';
import 'package:purchaseproject/utils/app_color.dart';
import 'package:purchaseproject/utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeContent(), 
    const OrderScreen(),
    ProfileScreen(),
  ];

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,

      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: "Orders"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}


class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isMobile = Responsive.isMobile(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 50,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.dashboard_customize,
                    color: AppColors.primary),

                IconButton(
                  icon: const Icon(Icons.logout,
                      color: AppColors.primary),
                  onPressed: () async {
                    await authProvider.logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Customer Order\nManagement",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleItem(Icons.add_box, "Create"),
                _circleItem(Icons.pending_actions, "Pending"),
                _circleItem(Icons.check_circle, "Completed"),
                _circleItem(Icons.cancel, "Cancelled"),
              ],
            ),

            const SizedBox(height: 30),

            _featureCard(
              context,
              title: "Create New Order",
              subtitle: "Add a new customer order",
              timeText: "Quick Action",
              color: Colors.lightBlue.shade100,
              imageUrl:
                  "https://images.pexels.com/photos/3184192/pexels-photo-3184192.jpeg",
              onTap: () {},
            ),

            const SizedBox(height: 20),

            _featureCard(
              context,
              title: "Manage Orders",
              subtitle: "View & Update customer orders",
              timeText: "Live Update",
              color: Colors.green.shade100,
              imageUrl:
                  "https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg",
              onTap: () {
                DefaultTabController.of(context);
              },
            ),
          ],
        ),
      ),
    );
  }


  static Widget _circleItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }


  static Widget _featureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String timeText,
    required Color color,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    final isMobile = Responsive.isMobile(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: isMobile ? 150 : 190,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(22)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(subtitle),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.play_arrow, size: 18),
                        const SizedBox(width: 6),
                        Text(timeText),
                      ],
                    ),
                  )
                ],
              ),
            ),

            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                imageUrl,
                width: isMobile ? 100 : 150,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
