import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../models/order.dart';
import '../models/service.dart';
import '../models/state.dart';
import '../utils/color.dart';
import '../widgets/customactionbuttons_widget.dart';
import '../widgets/customboxinformation_widget.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {

  const DetailScreen({
    Key? key,
    required this.service,
  }) : super(key: key);


  final Service? service;
  static String route = "detail";

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool showDate = false;
  bool showTime = false;
  List<Willaya?> willayas = [];
  double _currentSliderValue = 0;


  getState() async{
    willayas = (await Willaya.getState()!)!;
  }

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

// Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }

  String? getDate() {
    // ignore: unnecessary_null_comparison
    if (selectedDate == null) {
      return 'select date';
    } else {
      return DateFormat('MMM d, yyyy').format(selectedDate);
    }
  }
  String getTime(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  @override
  void initState() {
    getState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration:  const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.none,
              image: AssetImage('assets/maker.png'),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                decoration:  const BoxDecoration(
                  color: Colors.orange,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/maker.png'),
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: CustomActionButton(boxIcon: FontAwesomeIcons.chevronLeft),
                      ),
                      const Text(
                             "Painting(Category name) "
                            "Wall painting(Service name) .",
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.4,
                          fontSize: 12,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "1500da/Heure",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Number of Hours :",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                       Slider(
                      value: _currentSliderValue,
                      max: 8,
                      divisions: 8,
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                      const Text(
                        "Select Date : ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                          showDate = true;
                        },
                        child:  CustomBoxInformation(
                            boxIcon: FontAwesomeIcons.calendarCheck,
                            label:  showDate ? getDate()! :"DD/MM/AA"),
                      ),
                      InkWell(
                        onTap: () {
                          _selectTime(context);
                          showTime = true;
                        },
                        child: const Text(
                          "Select StartingTime : ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                       CustomBoxInformation(
                          boxIcon: FontAwesomeIcons.calendarCheck,
                          label:  showTime ? getTime(selectedTime) :"HH:MM"),

                      GestureDetector(
                        onTap: (() {
                          Map<String, dynamic> data = {
                            "client":"amine",
                            "hours":"03",
                            "date":"22/11/2022",
                            "start":"12:00",
                            "service":"Peinture",
                            "address":"Alger birkhadem",
                            "state":"alger"
                          };
                          Order.postOrder(data,context);
                        }),
                        child: Container(
                          alignment: Alignment.center,
                          width: Get.width,
                          height: 50,
                          decoration: BoxDecoration(
                              color: AppColor.primaryBlueColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                            r"BOOK NOW",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}