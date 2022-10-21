import 'package:badges/badges.dart';
import 'package:bricoli_app/models/category.dart';
import 'package:bricoli_app/utils/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../models/DBHelper.dart';
import '../models/orderProvider.dart';
import '../models/service.dart';
import '../models/cart_model.dart';
import '../utils/color.dart';
import 'service_page.dart';


class ServiceList extends StatefulWidget {
  final Category? category;
  const ServiceList({Key? key, required this.category}) : super(key: key);
  static String route = "listService";
  @override
  State<ServiceList> createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  DBHelper dbHelper = DBHelper();

  List<Service?> services = [];
  int _count = 0;
  bool isData = false;
  getData() async {

    if(widget.category.isNull) {
      services = (await Service.getService())!;
    } else {
      services = (await Category.getService(widget.category!.id))!;
    }

    setState(() {
      isData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  //List<bool> clicked = List.generate(10, (index) => false, growable: true);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    void saveData(int index) {
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
        ToastService.showErrorToast('Le service est deja ajouté');
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text(widget.category.isNull ? 'List des Services' : widget.category!.name ),
        backgroundColor: AppColor.primaryBlueColor,
        actions: [
          Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                _count = value.getCounter();
                return Text(
                  value.getCounter().toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
            position:  const BadgePosition(start: 22, bottom: 20),
            child: IconButton(
              onPressed: () {
                if(_count != 0 ){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen(isHome: false)));
                }
              },
              icon: Icon(_count == 0 ? Icons.shopping_cart_outlined : Icons.shopping_cart),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: AnimationLimiter(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: services.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredGrid(
                      columnCount: services.length,
                      position: index,
                      duration: const Duration(milliseconds: 1000),
                      child: ScaleAnimation(
                          child: FadeInAnimation(
                              delay: const Duration(milliseconds: 100),
                              child: InkWell(
                                onTap: (){
                                  saveData(index);
                                },
                                  child: listItem(services[index]!))))
                  );
                })),
      ),
    );
  }
}

Widget listItem(Service service) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      children: [
        Container(
          width:136,
          height: 100.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(service.img,),fit: BoxFit.fill,),
            color: Colors.blue,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width:136,
            height: 70.0,
            decoration:  BoxDecoration(
              color: AppColor.primaryBlueColor,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10.0),bottomRight: Radius.circular(10.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16,top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                   maxLines: 2,
                    style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: AppColor.backgroundColor),
                  ),
                  Text(
                    "${service.price} Da/h",
                    style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: AppColor.backgroundColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}