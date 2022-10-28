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
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  backgroundColor: AppColor.primaryBlueColor,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10)),
              onPressed: () {
                launch('mailto:bricolidari@gmail.com?subject=News&body=New%20plugin');
              },
              icon: const Icon(Icons.mail),
              label: const Center(
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
                child: ElevatedButton.icon(

              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  backgroundColor: AppColor.primaryBlueColor,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10)),
              onPressed: () {
                launch('tel:0555588208');
              },
                  icon: const Icon(Icons.phone),
              label: const Center(
                child: Text(
                  "0555588208",
                  style: TextStyle(color: Colors.white,fontSize: 18),
                ),
              ),

            ),
          ),
                    const SizedBox(
                      height: 16,
                    ),

 /***************************/

                    SizedBox(
                      height: 65,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            backgroundColor: AppColor.primaryBlueColor,
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10)),
                        onPressed: () {
                           launch("https://web.facebook.com/profile.php?id=100078770065946", forceSafariVC: false);
                        },
                        icon:  SvgPicture.asset(
                            "assets/icons/facebook.svg",
                          width: 35,
                          height: 35,
                        ),
                        label: const Center(
                          child: Text(
                            "Facebook",
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
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            backgroundColor: AppColor.primaryBlueColor,
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10)),
                        onPressed: () {
                         // launch("https://web.facebook.com/profile.php?id=100078770065946", forceSafariVC: false);
                        },
                        icon: SvgPicture.asset(
                            "assets/icons/tiktok.svg",
                          width: 35,
                          height: 35,
                        ),
                        label: const Center(
                          child: Text(
                            "Tik Tok",
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
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            backgroundColor: AppColor.primaryBlueColor,
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10)),
                        onPressed: () {
                          launch("https://www.instagram.com/bricoli_dari/", forceSafariVC: false);
                        },
                        icon: SvgPicture.asset(
                            "assets/icons/instagram.svg",
                          width: 35,
                          height: 35,
                        ),
                        label: const Center(
                          child: Text(
                            "Instagram",
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
