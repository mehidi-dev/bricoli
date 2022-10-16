import 'package:flutter/material.dart';

class SpecialistItem extends StatefulWidget {
  final String imagePath;
  final String? imageName;
  final String? color;
  final String? colortext;
  final int index;
  const SpecialistItem({
    Key? key,
    required this.imagePath,
    required this.imageName,
    required this.color,
    required this.colortext,
    required this.index,
  }) : super(key: key);

  @override
  State<SpecialistItem> createState() => _SpecialistItemState();
}

class _SpecialistItemState extends State<SpecialistItem> {


  List<Color> colors = [Colors.blue, Colors.amber, Colors.black,Colors.blue, Colors.amber, Colors.black,Colors.blue, Colors.amber, Colors.black];
  List<Color> colorText = [Colors.white, Colors.black, Colors.white,Colors.blue, Colors.amber, Colors.black];


  Color hexaColor(String strColor){
    strColor = strColor.replaceAll("#", "0xFF");
    return Color(int.parse(strColor));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color:  hexaColor("${widget.color}"),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
           backgroundImage:NetworkImage(widget.imagePath,)),
          const SizedBox(
            width: 8,
          ),
          Text(
            widget.imageName!,
            overflow:TextOverflow.ellipsis ,
            style:  TextStyle(fontSize: 14,color:  hexaColor("${widget.colortext}")),
          )
        ],
      ),
    );
  }
}
