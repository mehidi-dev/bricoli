import 'Package:Bricoli_Dari/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';

import '../models/DBHelper.dart';
import '../models/cart_model.dart';
import '../models/order.dart';
import '../models/orderProvider.dart';
import '../models/state.dart';
import '../utils/color.dart';
import '../widgets/customboxinformation_widget.dart';


class CartScreen extends StatefulWidget {
  final bool isHome ;
  const CartScreen({
    Key? key, required this.isHome,
  }) : super(key: key);
  static String route = "cart";
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _formkey = GlobalKey<FormState>();
  bool isSelected = true;
  int count = 0;
  double totalPrice = 0;
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
 bool isHome = false;
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
       if(element.numberHours.toInt() == 1 ) {
         totalPrice = totalPrice + int.parse("${element.price}") * (1.5);
       }else{
         totalPrice = totalPrice + int.parse("${element.price}") * element.numberHours.toInt();
       }

     }
     setState(() {
       totalPrice;
     });
  }
  @override
  void initState() {
    getState();
    isHome =  widget.isHome;
    super.initState();
    getCartProvider();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Mes services'),
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
                                            child: Text(cartService[index].numberHours == 1 ? "Nombre de heures: 1.5h" : "Nombre de heures: ${cartService[index].numberHours.round().toString()}H",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                          ),
                                          Slider(
                                            min: 1,
                                            value: cartService[index].numberHours,
                                            max: 8,
                                            divisions: 7,
                                            label: cartService[index].numberHours == 1 ? "1.5h" :"${cartService[index].numberHours.round().toString()}h",
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
                                            provider.cart[index].serviceId!);
                                        provider
                                            .removeItem(provider.cart[index].serviceId!);
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
                              child: Container( width: 400,
                                  padding: const EdgeInsets.all(16.0),
                                 decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/to_pay.png'), fit: BoxFit.fill),
                                  ),
                                  child: Text("Total prix: ${totalPrice.toInt()} DA",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22))),
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
                   setState(() {
                        isSelected = false;
                    });
                  if (_formkey.currentState!.validate() && showDate && showTime) {
                  showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
                    return AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                      contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),),
                      title: const Center(child:  Text(r"Votre panier")),
                      content: SingleChildScrollView(
                        child: SizedBox(
                          width: 600,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Services",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 60,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: cartService.length,
                                    //shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      return  Padding(
                                        padding:const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 180,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            color:    AppColor.backgroundColor,
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          child: Text(
                                              '${cartService[index].name}',
                                              overflow:TextOverflow.ellipsis ,
                                              style:  TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color:  AppColor.primaryDarkColor)),
                                        ),
                                      );
                                    }),
                              ),
                              const SizedBox(height: 12,),
                              Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColor.primaryBlueColor,
                                        width: 1
                                    )
                                ),
                                child:  Text("Nom: $name", overflow:TextOverflow.ellipsis , style: TextStyle(fontSize: 16,color: AppColor.primaryDarkColor,fontWeight: FontWeight.bold),

                              ),

                              ),
                              const SizedBox(height: 12,),
                              Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColor.primaryBlueColor,
                                        width: 1
                                    )
                                ),
                                child:  Text("Téléphone: $completeNumber",overflow:TextOverflow.ellipsis , style: TextStyle(fontSize: 16,color: AppColor.primaryDarkColor,fontWeight: FontWeight.bold)

                                ),

                              ),
                              const SizedBox(height: 12,),
                              Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColor.primaryBlueColor,
                                        width: 1
                                    )
                                ),
                                child:  Text("Téléphone: $completeNumber1",overflow:TextOverflow.ellipsis , style: TextStyle(fontSize: 16,color: AppColor.primaryDarkColor,fontWeight: FontWeight.bold)

                                ),

                              ),
                              const SizedBox(height: 12,),
                              Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColor.primaryBlueColor,
                                        width: 1
                                    )
                                ),
                                child:  Text("Willaya: $state",overflow:TextOverflow.ellipsis , style: TextStyle(fontSize: 16,color: AppColor.primaryDarkColor,fontWeight: FontWeight.bold)

                                ),

                              ),
                              const SizedBox(height: 12,),
                              Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColor.primaryBlueColor,
                                        width: 1
                                    )
                                ),
                                child:  Text("Adresse: $adress",overflow:TextOverflow.ellipsis , style: TextStyle(fontSize: 16,color: AppColor.primaryDarkColor,fontWeight: FontWeight.bold)

                                ),

                              ),
                              const SizedBox(height: 12,),
                              Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColor.primaryBlueColor,
                                        width: 1
                                    )
                                ),
                                child:  Text("La date: ${getDate()}",overflow:TextOverflow.ellipsis , style: TextStyle(fontSize: 16,color: AppColor.primaryDarkColor,fontWeight: FontWeight.bold)

                                ),

                              ),
                              const SizedBox(height: 12,),
                              Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColor.primaryBlueColor,
                                        width: 1
                                    )
                                ),
                                child:  Text("Heure de début: ${getTime(selectedTime)}",overflow:TextOverflow.ellipsis , style: TextStyle(fontSize: 16,color: AppColor.primaryDarkColor,fontWeight: FontWeight.bold)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SliderButton(
                              action: () {
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
                                    Navigator.of(context).pop(true);
                                    setState(() {
                                      isSelected = true;
                                    });
                                  } else {
                                    ToastService.showErrorToast("Vérifier les champs");
                                    setState(() {
                                      isSelected = true;
                                    });
                                  }

                              },
                              height: 50,
                              buttonSize: 40,
                              width: 200,
                              shimmer:false,
                              label:  Text(
                                r"Confirmer",
                                style: TextStyle(
                                    color: AppColor.backgroundColor, fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              icon:  Center(
                                  child: SvgPicture.asset('assets/checkout-svgrepo-com.svg',
                                    width: 22.0,
                                    height: 22.0,
                                  ),
                              ),
                              buttonColor: AppColor.backgroundColor,
                              backgroundColor: AppColor.primaryBlueColor,
                              highlightedColor: AppColor.primaryDarkColor,
                              baseColor: AppColor.backgroundColor,
                            ),
                            TextButton(
                              child: const Text("Annuler"),
                              onPressed:  () {
                                Navigator.of(context).pop(false);
                              },
                            )
                          ],
                        ),
                      ],
                    );
                  },
                  ).then((value) {
                    if (isHome == false) {
                      Navigator.of(context).pop();
                      print("dddddddd");
                    } else {
                      getCartProvider();
                    }
                  });
                } else {
                    ToastService.showErrorToast("Vérifier les champs");
                   setState(() {
                     isSelected = true;
                    });
                 }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlueColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: isSelected == true ? const Text(
                    r"Commander",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ): const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(backgroundColor: Colors.white),
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