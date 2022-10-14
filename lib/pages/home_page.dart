import 'package:badges/badges.dart';
import 'package:bricoli_app/pages/category_list.dart';
import 'package:bricoli_app/pages/product_list.dart';
import 'package:bricoli_app/pages/service_page.dart';
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
import '../widgets/search_form.dart';
import '../widgets/service_item.dart';
import '../widgets/specialist_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String route = "home";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _current = 0;
  int count = 0;
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
  void saveData(int index) {
    final cart = Provider.of<CartProvider>(context,listen: false);
    print(index);

    dbHelper
        .insert(
      Cart(
          id: index,
          serviceId: services[index]?.id,
          name: services[index]?.name,
          status: services[index]?.status,
          category: services[index]?.category,
          price: services[index]?.price,
          numberHours: 0,
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(''),
        backgroundColor: AppColor.primaryBlueColor,
        actions: [
          Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                count = value.getCounter();
                return Text(
                  value.getCounter().toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
            position: const BadgePosition(start: 30, bottom: 30),
            child: IconButton(
              onPressed: () {
                if(count != 0 ){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()));
                }
              },
              icon:  Icon(count == 0 ? Icons.shopping_cart_outlined : Icons.shopping_cart),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.black54,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month_outlined,
              color: Colors.black54,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.black54,
            ),
            label: '',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                     Container(
                      height: size.height / 7,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Image.asset(
                        "assets/start.jpeg",
                        // height: 50,
                      ),
                    ),

                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: defaultPadding),
                  child: SearchForm(),
                ),
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
                                ?  Colors.red
                                : Colors.blue,
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
                      "Categories",
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
                            context,MaterialPageRoute(builder: (context) =>  const CategoryList()),);
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
      ),
    );
  }
}
