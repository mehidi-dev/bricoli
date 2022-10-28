import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/color.dart';
import 'home_page.dart';

class StartedPage extends StatefulWidget {
  const StartedPage({Key? key}) : super(key: key);

  @override
  State<StartedPage> createState() => _StartedPageState();
}

class _StartedPageState extends State<StartedPage> {
    bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Container(
                height: size.height / 2.2,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Image.asset('assets/start.png',
                width: 180,
                height: 180,)
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Après le bricolage on aura besoin de nettoyage, "
                          "L'application NEQILI DARI",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: InkWell(
                          onTap: () async{
                        if (Platform.isIOS ) {
                          await launch("https://apps.apple.com/dz/app/neqili-dari/id1576690644?|=fr");
                        } else {
                          await launch("https://play.google.com/store/apps/details?id=com.immo_multiservising.na9ili_dari");
                        }

                          },
                          child: Image.asset('assets/start1.png',
                            width: 70,
                            height: 70,),
                        )
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          isSelected = false;
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return const HomePage();
                            })).then((value) {
                          setState(() {
                            isSelected = true;
                          });
                        });
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlueColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:  Center(
                          child: isSelected == true ? const Text(
                            "Commencer",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ) :  const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(backgroundColor: Colors.white),
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
