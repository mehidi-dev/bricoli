import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/color.dart';
import 'home_page.dart';

class FeqPage extends StatefulWidget {
  const FeqPage({Key? key}) : super(key: key);
  static String route = "feq";
  @override
  State<FeqPage> createState() => _FeqPageState();
}

class _FeqPageState extends State<FeqPage> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16,
              ),
              Container(
                height: size.height / 2.2,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Image.asset('assets/start.png',
                  width: 180,
                  height: 180,),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                      SizedBox(
            height: 65,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  backgroundColor: AppColor.primaryBlueColor,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
              onPressed: () {
                launch('mailto:bricolidari@gmail.com?subject=News&body=New%20plugin');
              },
              child: const Center(
                child: Text(
                  "bricolidari@gmail.com",
                  style: TextStyle(color: Colors.white,fontSize: 18),
                ),
              ),
            ),
          ),
                      const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
              height: 65,
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  backgroundColor: AppColor.primaryBlueColor,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
              onPressed: () {
                launch('tel:0555588208');
              },
              child: const Center(
                child: Text(
                  "0555588208",
                  style: TextStyle(color: Colors.white,fontSize: 18),
                ),
              ),
            ),
          ),
                    const SizedBox(
                      height: 32,
                    ),
            ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
