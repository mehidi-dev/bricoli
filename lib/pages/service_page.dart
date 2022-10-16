import 'package:badges/badges.dart';
import 'package:bricoli_app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/DBHelper.dart';
import '../models/cart_model.dart';
import '../models/order.dart';
import '../models/orderProvider.dart';
import '../models/state.dart';
import '../utils/color.dart';
import '../widgets/customboxinformation_widget.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);
  static String route = "cart";
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _formkey = GlobalKey<FormState>();
  int count = 0;
  int totalPrice = 0;
   OutlineInputBorder outlineInputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none,
  );
  DBHelper? dbHelper = DBHelper();
  List<bool> tapped = [];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool showDate = false;
  bool showTime = false;
  List<Willaya?> willayas = [];
  List<Willaya?> willayasActive = [];
  String state  ="";
  String name  ="";
  String completeNumber  ="";
  String completeNumber1  ="";
  String adress  ="";
  List<Cart> cartService = [];
  List<Cart> cartData = [];

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
      return DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  String getTime(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format =  DateFormat('HH:mm').format(dt);
    return format;
  }
  getState() async{
    willayasActive = [];
    willayas = (await Willaya.getState())!;
    for (var element in willayas) {
      if(element!.status == "active"){
        willayasActive.add(element);
      }
    }
    setState(() {
      state = willayas.first!.name;
    });
  }
  getCartProvider()  async {
    cartService = await context.read<CartProvider>().getData();
    calculePrice();
  }
   calculePrice(){
     totalPrice = 0;
     for (var element in cartService) {
    totalPrice = totalPrice + int.parse("${element.price}") * element.numberHours.toInt();
     }
     setState(() {
       totalPrice;
     });
  }
  @override
  void initState() {
    getState();
    super.initState();
    getCartProvider();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mes services'),
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
            position: const BadgePosition(start: 30, bottom: 30),
            child: IconButton(
              onPressed: () {},
              icon: Icon(count == 0 ? Icons.shopping_cart_outlined : Icons.shopping_cart),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
        ],
        backgroundColor: AppColor.primaryBlueColor,
      ),
      body: SingleChildScrollView(
        child: Consumer<CartProvider>(
          builder: (BuildContext context, provider, widget) {
            if (provider.cart.isEmpty) {
              return const SizedBox(
                height: 500,
                child: Center(
                    child: Text(
                      r'Votre panier est vide',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    )),
              );
            } else {
              return  Column(
                children: [
                  SizedBox(
                    height: 315,
                    child: ListView.builder(
                        itemCount: cartService.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Container(
                                  width: 230.0,
                                  height: 200.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(cartService[index].img!,),fit: BoxFit.fill,),
                                    color: Colors.blue,
                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: 230.0,
                                    height: 150.0,
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
                                            "${cartService[index].name}",
                                            overflow:TextOverflow.ellipsis ,
                                            style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: AppColor.backgroundColor),
                                          ),
                                          Text(
                                            "${cartService[index].price} Da/h",
                                            style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: AppColor.backgroundColor),
                                          ),
                                           Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text("Nombre de heures: ${cartService[index].numberHours.round().toString()}H",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                          ),
                                          Slider(
                                            value: cartService[index].numberHours,
                                            max: 8,
                                            divisions: 8,
                                            label: "${cartService[index].numberHours.round().toString()}h",
                                            onChanged: (double value) {
                                              setState(() {
                                                cartService[index].numberHours = value;
                                              });
                                              calculePrice();
                                            },
                                            activeColor: Colors.white,
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  bottom: 0,
                                  child: IconButton(
                                      onPressed: () {
                                        dbHelper!.deleteCartItem(
                                            provider.cart[index].id!);
                                        provider
                                            .removeItem(provider.cart[index].id!);
                                        provider.removeCounter();
                                        getCartProvider();
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 24,
                                      )),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  Form(
                    key: _formkey,
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0,bottom: 8),
                              child: Text("Total prix: $totalPrice DA",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 32)),
                            ),
                            const Text(
                              "Nom:",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (String? value) {
                                  if (value !=null && value.isEmpty ) {
                                    return "Le nom ne peut pas être vide";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor:Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),

                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                ),

                                onChanged: (value){
                                  name = value.trim();
                                },
                              ),
                            ),
                            const Text(
                              "Téléphone:",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (String? value) {
                                  if (value !=null && value.isEmpty ) {
                                    return "Le téléphone ne peut pas être vide";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor:Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),

                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                ),

                                onChanged: (value){
                                  completeNumber = value.trim();
                                },
                              ),
                            ),
                            const Text(
                              "Deuxième téléphone:",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                onSaved: (value) {},
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor:Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),

                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                ),

                                onChanged: (value){
                                  completeNumber1 = value.trim();
                                },
                              ),
                            ),
                            const Text(
                              "Sélectionner la willaya:",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            willayas.isNotEmpty ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField<Willaya>(
                                value: willayasActive.first,
                                decoration: const InputDecoration(
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                ),
                                items: willayasActive
                                    .map(
                                      (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      "${e?.name}",
                                    ),
                                  ),
                                )
                                    .toList(),
                                onChanged: (key) {
                                  state = key!.name;
                                },
                              ),
                            ) : const SizedBox(height: 10),
                            const Text(
                              "Adresse:",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (String? value) {
                                  if (value !=null && value.isEmpty ) {
                                    return "L'adresse ne peut pas être vide";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor:Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                ),
                                onChanged: (value){
                                  adress = value.trim();
                                },
                              ),
                            ),
                            const Text(
                              "Sélectionner une date:",
                              style: TextStyle(
                                fontSize: 15,
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
                            const Text(
                              "Sélectionnez Heure de début:",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _selectTime(context);
                                showTime = true;
                              },
                              child: CustomBoxInformation(
                                  boxIcon: FontAwesomeIcons.businessTime,
                                  label:  showTime ? getTime(selectedTime) :"HH:MM"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 12),
        child: Consumer<CartProvider>(
          builder: (BuildContext context, provider, widget) {
            if (provider.cart.isEmpty) {
              return  Container(child: const Text(""),);
            } else {
              return  InkWell(
                onTap: () {
                  List<Map<String, dynamic>> services = [];
                  bool isDone = false;
                  if (_formkey.currentState!.validate() && showDate && showTime) {
                    for (var element in cartService) {
                      for (var ele in services) {
                        if(ele['service'] == element.name ){
                          isDone = true;
                        }
                      }
                      if(!isDone){
                        services.add(
                            {
                              "service":element.name,
                              "hours":element.numberHours.toInt(),
                            }
                        );
                      }
                    }

                    Map<String, dynamic> data = {
                      "client":name,
                      "date":getDate()!,
                      "start":getTime(selectedTime),
                      "service":services,
                      "address":adress,
                      "phone1":completeNumber,
                      "phone2":completeNumber1,
                      "state":state
                    };
                    Order.postOrder(data,context);
                    dbHelper!.deleteCart();
                    cart.initCounter();
                  } else {
                    ToastService.showErrorToast("Vérifier les champs");
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlueColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    r"Commander",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback deleteQuantity;
  final VoidCallback addQuantity;
  final String text;
  const PlusMinusButtons(
      {Key? key,
        required this.addQuantity,
        required this.deleteQuantity,
        required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: deleteQuantity, icon: const Icon(Icons.remove)),
        Text(text),
        IconButton(onPressed: addQuantity, icon: const Icon(Icons.add)),
      ],
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({Key? key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}