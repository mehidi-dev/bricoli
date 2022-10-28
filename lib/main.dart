import 'Package:Bricoli_Dari/pages/category_list.dart';
import 'Package:Bricoli_Dari/pages/detail_page.dart';
import 'Package:Bricoli_Dari/pages/feq.dart';
import 'Package:Bricoli_Dari/pages/home_page.dart';
import 'Package:Bricoli_Dari/pages/product_list.dart';
import 'Package:Bricoli_Dari/pages/service_category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'Package:Bricoli_Dari/pages/started.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

import 'models/orderProvider.dart';
import 'pages/service_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'Bricoli',
        debugShowCheckedModeBanner: false,
        routes: {
          HomePage.route: (_) => const HomePage(),
          DetailScreen.route: (context) => const DetailScreen(service: null),
          CartScreen.route: (context) => const CartScreen(isHome: false),
          ServiceList.route: (context) => const ServiceList(category: null),
          CategoryList.route: (context) => const CategoryList(),
          FeqPage.route: (context) => const FeqPage(),
          ServiceCategoryList.route: (context) => const ServiceCategoryList(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
          home: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SplashScreen(
                  seconds: 3,
                  navigateAfterSeconds: const StartedPage(),
                  backgroundColor: Colors.white,
                  image: Image.asset('assets/start.png'),
                  photoSize: 90,
                  useLoader: false,

                ),
              ),
            ),
          )
      ),
    );
  }
}
