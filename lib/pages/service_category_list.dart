import 'package:badges/badges.dart';
import 'package:bricoli_app/models/category.dart';
import 'package:bricoli_app/utils/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../models/DBHelper.dart';
import '../models/orderProvider.dart';
import '../models/service.dart';
import '../models/cart_model.dart';
import '../utils/color.dart';
import '../widgets/search_form.dart';
import '../widgets/specialist_item.dart';
import 'service_page.dart';


class ServiceCategoryList extends StatefulWidget {
  const ServiceCategoryList({Key? key}) : super(key: key);
  static String route = "serviceCategoryList";
  @override
  State<ServiceCategoryList> createState() => _ServiceCategoryListState();
}

class _ServiceCategoryListState extends State<ServiceCategoryList> {
  DBHelper dbHelper = DBHelper();
   OutlineInputBorder outlineInputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );
  List<Category?> categories = [];
  List<Category?> displayCategories = [];
  int indexSelected = 0;
  int count = 0;
  getData() async {
    categories = (await Category.getCategory())!;
    for (var element in categories) {
      element?.services = (await Category.getService(element.id))!;
    }
     setState(() {
       displayCategories = categories;
     });
  }
   findCategory(String value) async {
     if(value.isNotEmpty) {
       List<Category?> findCategories = [];
       for (var element in categories) {
         if(element!.name == value) {
           findCategories.add(element);
         }
       }
       setState(() {
         displayCategories = findCategories;
       });
     } else {
       getData();
     }

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
    void saveData(Service service) {

      print("index");
      dbHelper
          .insert(
        Cart(
          serviceId: service.id,
          name: service.name,
          status: service.status,
          category: service.category,
          price: service.price,
          numberHours: 1,
          img: service.img,
        ),
      ).then((value) {
        cart.addCounter();
        print('Product Added to cart');
      }).onError((error, stackTrace) {
        ToastService.showErrorToast('Le service est deja ajouté');
      });
    }

    return Scaffold(
      appBar:   AppBar(
        centerTitle: true,
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
            position: const BadgePosition(start: 22, bottom: 20),
            child: Icon(count == 0 ? Icons.shopping_cart_outlined : Icons.shopping_cart,color: Colors.black54,),
          ),
          const SizedBox(
            width: 20.0,
          ),
        ],
        backgroundColor: AppColor.primaryBlueColor,
      ) ,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child:  Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
                child:  Form(
                  child:  TextFormField(
                    onChanged: (value) async {
                      await findCategory(value);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Search ...",
                      border: outlineInputBorder,
                      enabledBorder: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      errorBorder: outlineInputBorder,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(14),
                        child: SvgPicture.asset("assets/icons/Search.svg"),
                      ),
                      /*  suffixIcon: Padding(
                  padding:  const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding / 2),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.primaryBlueColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      onPressed: () {},
                      child: SvgPicture.asset("assets/icons/Filter.svg"),
                    ),
                  ),
                ),*/
                    ),
                  ),
                ),
              ),
              SizedBox(
              height: 60,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            indexSelected = 0;
                          });
                          await getData();
                        },
                        child: Container(
                          width: 50,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color:  indexSelected == 0 ? AppColor.primaryBlueColor  : AppColor.backgroundColor,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                  'All',
                                  overflow:TextOverflow.ellipsis ,
                                  style:  TextStyle(fontSize: 14,color:  indexSelected == 0 ?  AppColor.backgroundColor :  AppColor.primaryDarkColor)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return  Padding(
                              padding:const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    indexSelected = index + 1 ;
                                  });
                                  findCategory(categories[index]!.name);
                                },
                                child: Container(
                                  width: 120,
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color:   indexSelected == index +1   ? AppColor.primaryBlueColor  : AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                          '${categories[index]?.name}',
                                        overflow:TextOverflow.ellipsis ,
                                        style:  TextStyle(fontSize: 14,color: indexSelected == index +1   ?  AppColor.backgroundColor :  AppColor.primaryDarkColor)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: displayCategories.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return  Padding(
                        padding:const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${displayCategories[index]?.name}",
                              overflow:TextOverflow.ellipsis ,
                           style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: SizedBox(
                                height: 150.0,
                                child: AnimationLimiter(
                                    child: ListView.builder(
                                        itemCount: displayCategories[index]?.services.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (BuildContext context, int ind) {
                                          return AnimationConfiguration.staggeredGrid(
                                              columnCount: displayCategories[index]!.services.length,
                                              position: ind,
                                              duration: const Duration(milliseconds: 1000),
                                              child: ScaleAnimation(
                                                  child: FadeInAnimation(
                                                      delay: const Duration(milliseconds: 100),
                                                      child: InkWell(
                                                          onTap: (){
                                                            saveData(displayCategories[index]!.services[ind]!);
                                                          },
                                                          child: listItem(displayCategories[index]!.services[ind]!))))
                                          );
                                        })),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),

        ),
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