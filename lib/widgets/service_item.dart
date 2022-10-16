import 'package:bricoli_app/utils/color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class ServiceItem extends StatelessWidget {
  final String? image;
  final String? name;
  final String? prix;
  final String? specialist;
  const ServiceItem({
    Key? key,
    required this.image,
    required this.name,
    required this.prix,
    required this.specialist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: 230.0,
            height: 200.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('$image',),fit: BoxFit.fill,),
              color: Colors.blue,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
              width: 230.0,
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
                    "$name",
                    overflow:TextOverflow.ellipsis ,
                    style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: AppColor.backgroundColor),
                  ),
                  Text(
                    "$prix Da/h",
                    style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: AppColor.backgroundColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
