import 'package:flutter/material.dart';
import 'package:purchaseproject/utils/responsive.dart';


class AppColors {
  static const primary = Color(0xFF0A4D8C);
  static const lightBlue = Color(0xFFEAF4FF);
  static const darkBlue = Color(0xFF083C6D);
}

class HomeContent extends StatefulWidget {
  const HomeContent();

  @override
  State<HomeContent> createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> {
  Duration offerTime = const Duration(hours: 5);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (offerTime.inSeconds > 0) {
        setState(() {
          offerTime -= const Duration(seconds: 1);
        });
        _startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    // List of products for Best Sellers
    final bestSellers = [
      {
        'image': "https://i.pinimg.com/736x/08/da/63/08da63ade4b3e9f1017e74cadb07dd06.jpg",
        'title': "Best Seller Product 1",
        'price': 999,
      },
      {
        'image': "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUm-f3O-wdwvQgXQnRYAGc6g2BAPy4Ty5w4A&s",
        'title': "Best Seller Product 2",
        'price': 799,
      },
      {
        'image': "https://photos.vardanethnic.in/media/2024/08/ladies-flavour-rangrez-pure-silk-wholesale-gown-with-dupatta-collection-3.webp",
        'title': "Best Seller Product 3",
        'price': 599,
      },
      {
        'image': "https://hips.hearstapps.com/hmg-prod/images/best-flip-phones1-67b4f279c33ae.jpg?crop=0.563xw:1.00xh;0.196xw,0&resize=1120:*",
        'title': "Best Seller Product 4",
        'price': 1299,
      },
      {
        'image': "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi-pJWE66oeIASXSnF6-9l0S_V_jWBqTKGdg&s",
        'title': "Best Seller Product 5",
        'price': 849,
      },
      {
        'image': "https://www.mystore.in/s/62ea2c599d1398fa16dbae0a/665715991691e4002b9c5c9e/white-shoes-4.jpg",
        'title': "Best Seller Product 6",
        'price': 1399,
      },
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔝 Header
            const Text(
              "Shop Smart 🛍️",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// 🎞️ Banner Slider with new images
            SizedBox(
              height: isMobile ? 160 : 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      // Updated image URLs
                      index == 0
                          ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ34olbR_FxkdTxszKsPDFfMR-eD2SM-jmq2g&s"
                          : index == 1
                              ? "https://cdn.jiostore.online/v2/jmd-asp/jdprod/wrkr/company/1/applications/645a057875d8c4882b096f7e/theme/pictures/free/original/theme-image-1746771413928.jpeg"
                              : "https://thumbs.dreamstime.com/b/electronics-shop-sale-flyer-banner-creative-poster-discount-offer-67250954.jpg",
                      width: isMobile ? 280 : 380,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            /// ⏳ Limited Time Offer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "🔥 Limited Time Offer",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${offerTime.inHours.toString().padLeft(2, '0')}:" 
                    "${(offerTime.inMinutes % 60).toString().padLeft(2, '0')}:" 
                    "${(offerTime.inSeconds % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ⭐ Best Sellers (replacing Featured Products)
            const Text(
              "Best Sellers",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Best Sellers Grid (Updated content)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bestSellers.length, // Use the length of the list
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 2 : 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final item = bestSellers[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item['image'] as String, // Explicit cast to String
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['title'] as String, // Explicit cast to String
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "₹${item['price']}",
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}



// class HomeContent extends StatefulWidget {
//   const HomeContent();

//   @override
//   State<HomeContent> createState() => HomeContentState();
// }

// class HomeContentState extends State<HomeContent> {
//   Duration offerTime = const Duration(hours: 5);

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     Future.delayed(const Duration(seconds: 1), () {
//       if (offerTime.inSeconds > 0) {
//         setState(() {
//           offerTime -= const Duration(seconds: 1);
//         });
//         _startTimer();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isMobile = Responsive.isMobile(context);

//     return SafeArea(
//       child: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(
//           horizontal: isMobile ? 16 : 40,
//           vertical: 20,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// 🔝 Header
//             const Text(
//               "Shop Smart 🛍️",
//               style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 20),

//             /// 🎞️ Banner Slider with new images
//             SizedBox(
//               height: isMobile ? 160 : 220,
//               child: ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 3,
//                 separatorBuilder: (_, __) => const SizedBox(width: 12),
//                 itemBuilder: (context, index) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Image.network(
//                       // Updated image URLs
//                       index == 0
//                           ? "https://images.pexels.com/photos/5632397/pexels-photo-5632397.jpeg"
//                           : index == 1
//                               ? "https://images.pexels.com/photos/4720364/pexels-photo-4720364.jpeg"
//                               : "https://images.pexels.com/photos/1741261/pexels-photo-1741261.jpeg",
//                       width: isMobile ? 280 : 380,
//                       fit: BoxFit.cover,
//                     ),
//                   );
//                 },
//               ),
//             ),

//             const SizedBox(height: 25),

//             /// ⏳ Limited Time Offer
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: AppColors.primary,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "🔥 Limited Time Offer",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "${offerTime.inHours.toString().padLeft(2, '0')}:" 
//                     "${(offerTime.inMinutes % 60).toString().padLeft(2, '0')}:" 
//                     "${(offerTime.inSeconds % 60).toString().padLeft(2, '0')}",
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold),
//                   )
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             /// ⭐ Best Sellers (replacing Featured Products)
//             const Text(
//               "Best Sellers",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 16),

//             // Best Sellers Grid (Updated content)
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: 6, // Updated number of best sellers
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: isMobile ? 2 : 4,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 16,
//                 childAspectRatio: 0.7,
//               ),
//               itemBuilder: (context, index) {
//                 return Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     boxShadow: const [
//                       BoxShadow(color: Colors.black12, blurRadius: 6)
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.network(
//                             "https://images.pexels.com/photos/5632397/pexels-photo-5632397.jpeg",  // Updated image for best sellers
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text("Best Seller Product",
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       const Text("₹999",
//                           style: TextStyle(
//                               color: AppColors.primary,
//                               fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



