import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBoxInformation extends StatelessWidget {
  const CustomBoxInformation({
    Key? key,
    required this.boxIcon,
    required this.label,
  }) : super(key: key);
  final IconData boxIcon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: Get.height * 0.1,
      decoration: BoxDecoration(
          border: Border.all(
            width: 1.6,
            color: const Color.fromARGB(123, 255, 249, 249),
          ),
          borderRadius: BorderRadius.circular(11)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              boxIcon,
              color:   Colors.black,
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style:  const TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}