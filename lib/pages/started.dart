import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/color.dart';
import 'home_page.dart';

class StartedPage extends StatefulWidget {
  const StartedPage({Key? key}) : super(key: key);

  @override
  State<StartedPage> createState() => _StartedPageState();
}

class _StartedPageState extends State<StartedPage> {
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
                      "Tous les services dans une seule application",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        right: 20,
                      ),
                      child: Text(
                        "Trouvez votre artisan et prenez rendez-vous en un clic",
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const HomePage();
                      })),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlueColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            "Commencer",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
