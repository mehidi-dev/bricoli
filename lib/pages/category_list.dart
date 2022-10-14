import 'package:badges/badges.dart';
import 'package:bricoli_app/models/category.dart';
import 'package:bricoli_app/pages/product_list.dart';
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


class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);
  static String route = "category";
  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  DBHelper dbHelper = DBHelper();
  List<Category?> categories = [];
  bool isData = false;
  getData() async{
    categories = (await Category.getCategory()!)!;
    setState(() {
      isData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('List des categories'),
        backgroundColor: AppColor.primaryBlueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: AnimationLimiter(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredGrid(
                      columnCount: 12,
                      position: index,
                      duration: const Duration(milliseconds: 1000),
                      child: ScaleAnimation(
                          child: FadeInAnimation(
                              delay: const Duration(milliseconds: 100),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,MaterialPageRoute(builder: (context) =>   ServiceList(category: categories[index],)),);
                                },
                                  child: listItem(categories[index]!))))
                  );
                })),
      ),
    );
  }
}

Widget listItem(Category category) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      children: [
        Container(
          width: 230.0,
          height: 200.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(category.img,),fit: BoxFit.fill,),
            color: Colors.blue,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: 230.0,
            height: 60.0,
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
                    category.name,
                    overflow:TextOverflow.ellipsis ,
                    style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: AppColor.primaryLightColor),
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