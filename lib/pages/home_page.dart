import 'package:badges/badges.dart';
import 'Package:Bricoli_Dari/pages/product_list.dart';
import 'Package:Bricoli_Dari/pages/service_category_list.dart';
import 'Package:Bricoli_Dari/pages/service_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/DBHelper.dart';
import '../models/cart_model.dart';
import '../models/category.dart';
import '../models/orderProvider.dart';
import '../models/service.dart';
import '../utils/color.dart';
import '../utils/toast.dart';
import '../widgets/service_item.dart';
import '../widgets/specialist_item.dart';
import 'feq.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String route = "home";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _current = 0;
  int count = 0;
  int _currentIndex = 0;
  List<Category?> categories = [];
  List<Service?> services = [];
   bool isData = false;
  DBHelper dbHelper = DBHelper();

  Color hexaColor(String strColor){
    strColor = strColor.replaceAll("#", "0xFF");
    return Color(int.parse(strColor));
  }
  getData() async{
    categories = (await Category.getCategory()!)!;
    services = (await Service.getService()!)!;
    setState(() {
      isData = true;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void saveData(int index) {
    final cart = Provider.of<CartProvider>(context,listen: false);
    print(index);

    dbHelper
        .insert(
      Cart(
          serviceId: services[index]?.id,
          name: services[index]?.name,
          status: services[index]?.status,
          category: services[index]?.category,
          price: services[index]?.price,
          numberHours: 1,
         img: services[index]?.img,
      ),
    ).then((value) {
      cart.addCounter();
      print('Product Added to cart');
    }).onError((error, stackTrace) {
      print(error);
      ToastService.showErrorToast('Le service est deja ajouté');
    });
  }
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColor.primaryBlueColor,
        unselectedItemColor: AppColor.primaryDarkColor,
        type: BottomNavigationBarType.fixed,
        iconSize: 32,
        currentIndex: _currentIndex,
        unselectedFontSize: 12,
        selectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: onTabTapped,
        items:  [
          const BottomNavigationBarItem(

            icon: Icon(
              Icons.home,
              color: Colors.black54,
            ),
            label: 'ACCUEIL',
          ),
           BottomNavigationBarItem(
            label: 'PANIER',
           icon: Consumer<CartProvider>(
             builder: (context, value, child) {
               count = value.getCounter();
               return Badge(
                 badgeContent : Text(
                   value.getCounter().toString(),
                   style: const TextStyle(
                       color: Colors.white, fontWeight: FontWeight.bold),
                 ),
                 position: const BadgePosition(start: 22, bottom: 20),
                 child: Icon(count == 0 ? Icons.shopping_cart_outlined : Icons.shopping_cart,color: Colors.black54,),
               );
             },
           )
          ),
           const BottomNavigationBarItem(
            icon: Icon(
              Icons.contacts,
              color: Colors.black54,
            ),
            label: 'CONTACT',
          ),
        ],
      ),
      body: _currentIndex == 0 ?  SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                Column(
                  children: [
                    CarouselSlider(
                        options: CarouselOptions(
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            autoPlay: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                        items: [0,1,2,3].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return InkWell(
                                onTap: (){
                                  // Navigator.push(context,MaterialPageRoute(builder: (context) =>  const DetailScreen(service: null,)),);
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 200.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/slide$i.jpeg'),fit: BoxFit.fill,),
                                    color: Colors.blue,
                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                ),

                              );
                            },
                          );
                        }).toList()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [0,1,2,3].map((i) {
                        int index = [0,1,2,3].indexOf(i);
                        return Container(
                          height: 10,
                          width: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ?  AppColor.primaryBlueColor
                                : AppColor.primaryDarkColor,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    const Text(
                      "Catégories",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: InkWell(
                        onTap: (){
                          //Navigator.push(context,MaterialPageRoute(builder: (context) =>  const CategoryList()),);
                          Navigator.push(context,MaterialPageRoute(builder: (context) =>  const ServiceCategoryList()),);
                        },
                        child: const Text(
                          "Voir tout",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 60,
                  child:
                  ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return  Padding(
                          padding:const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                context,MaterialPageRoute(builder: (context) =>   ServiceList(category: categories[index],)),);
                            },
                            child: SpecialistItem(
                              imagePath: '${categories[index]?.img}',
                              imageName: categories[index]?.name,
                              index: index,
                              color: categories[index]?.color,
                              colortext: categories[index]?.colortext,
                            ),
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    const Text(
                      "Services",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                            context,MaterialPageRoute(builder: (context) =>  const ServiceList(category: null,)),);
                        },
                        child: const Text(
                          "Voir tout",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: services.length,
                      itemBuilder: (BuildContext context, int index) {
                        return  InkWell(
                          onTap: (){
                            saveData(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ServiceItem(
                              image: services[index]?.img,
                              name: services[index]?.name,
                              specialist: services[index]?.name,
                              prix:services[index]?.price,
                            ),
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ) : _currentIndex == 1 ? const CartScreen(isHome: true) : const FeqPage(),
    );
  }
}
