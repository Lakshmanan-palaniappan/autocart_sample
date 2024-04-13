import 'package:audioplayers/audioplayers.dart';
import 'package:autocart/pages/payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slide_to_act/slide_to_act.dart';

class Scanner_B extends StatefulWidget {
  final String user;
  final List<List<dynamic>> items;
  const Scanner_B({Key? key,required this.user,required this.items}) : super(key: key);

  @override
  State<Scanner_B> createState() => _Scanner_BState(user,items);
}

class _Scanner_BState extends State<Scanner_B> {
  final List<List<dynamic>> items;
  final String user;
  int total = 0;
  List<String> scannedBarcodes = [];
  List<String> name = [];
  List<int> price = [];
  final player=AudioPlayer();
  _Scanner_BState(this.user,this.items);

  List<String> check(String barcode){
    List<String> result = ['Undefined Item!!','0'];
    for(var item in items)
      {

        if(identical(item[0], int.parse(barcode)))
          {
            return [item[1], item[2].toString()];
            //break;
          }
      }
    return [];


  }

  Widget item(int index) {
    if (index < 0 || index >= price.length) {
      return SizedBox();
    }
    int p = price[index];
    final itemKey = GlobalKey();
    return AnimatedSwitcher(
      duration:  Duration(milliseconds: 500),
      child: Dismissible(
        key: itemKey,
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20.0),
          color: Colors.red,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            scannedBarcodes = List.from(scannedBarcodes)..removeAt(index);
          });
        },
        child: Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(5.0),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 100,

                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.lightGreenAccent,
                ),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),

                child: Center(
                  child: Padding(

                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Text(
                        name[index],
                        style: TextStyle(
                          fontFamily: 'Muller',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12.0,

                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4,),
              Expanded(
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "₹$p.0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          GestureDetector(
              child: Icon(
                  Icons.qr_code_scanner
              ),
            onTap: scanBarcode,

          ),
          SizedBox(width: 6.0,),
          IconButton(onPressed: (){}, icon: Icon(Icons.info_outline))
        ],
        backgroundColor: Colors.lightGreenAccent,
        centerTitle: true,
        elevation: 0,
        title: Text("AutoCart",style: TextStyle(
          fontFamily: 'Battery',
          fontWeight: FontWeight.bold
        ),),
      ),
      body: Stack(
        children: [
          scannedBarcodes.isEmpty
              ? Center(
            child: Text(
              "Add Products !",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Muller"
              ),
            ),
          ):
          ListView.builder(

            itemCount: scannedBarcodes.length,
            itemBuilder: (context, index) {
              print(index);
              return item(index);
            },
          ),
          scannedBarcodes.isEmpty
              ? Center(
            child: Text(
              "Add Products !",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "Muller"
              ),
            ),
          ):
          Padding(

            padding: const EdgeInsets.all(12.0),
            child: SlideAction(
              alignment: Alignment.bottomCenter,
              elevation: 0,
              borderRadius: 12.0,
              innerColor: Colors.black,
              outerColor: Colors.green,
              animationDuration: Duration(milliseconds: 1000),
              text: "Pay RS.$total.0",
              textStyle: TextStyle(
                color: Colors.black,
                fontFamily: "Muller",
                fontWeight: FontWeight.bold,
                fontSize: 14
              ),
              sliderButtonIcon: Icon(Icons.fast_forward,color: Colors.lightGreenAccent,size: 25,),
              onSubmit: ()async{

                Navigator.push(context, MaterialPageRoute(builder: (context)=>Payment_Page()));
                var product=<String,dynamic>{};
                int i = 0;
                for(var item in scannedBarcodes)
                {
                  i++;
                  String p = 'pd'+i.toString();
                  product.addAll({p: item});
                }
                await FirebaseFirestore.instance.collection(user).add(product);

              },
            ),
          )

        ],

      ),

      /*floatingActionButton: FloatingActionButton.extended(

        onPressed: ()async{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Payment_Page()));
          var product=<String,dynamic>{};
          int i = 0;
          for(var item in scannedBarcodes)
            {
              i++;
              String p = 'pd'+i.toString();
              product.addAll({p: item});
            }
          await FirebaseFirestore.instance.collection(user).add(product);

        },
        tooltip: 'Pay',
        icon: Icon(Icons.payments_outlined),
        label: Text("Pay RS.$total.0"),
        backgroundColor: Colors.lightGreenAccent,
        *//*onPressed: (){},
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        tooltip: 'Pay',
        backgroundColor: Colors.lightGreenAccent,
        child: Icon(
            Icons.fast_forward,
          size: 30,
        ),*//*
      ),*/
    );
  }

  Future<void> scanBarcode() async {
    //player.play(AssetSource('beep-04.mp3'));
    final barcode = await FlutterBarcodeScanner.scanBarcode(
      "#d5e9f3",
      "Close",
      true,
      ScanMode.BARCODE,
    );
    if (barcode != '-1') {

      scannedBarcodes.add(barcode);
      List<String> ans = check(barcode);
      if (ans.isNotEmpty) {
        player.play(AssetSource('beep-04.mp3'));
        scannedBarcodes.add(barcode);
        name.add(ans[0]);
        price.add(int.parse(ans[1]));
        setState(() {total+=int.parse(ans[1]);});
        await scanBarcode();
      } else {
        player.play(AssetSource('beep-10.mp3'));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  height: 90,
                    decoration: BoxDecoration(
                      color: Color(0xFFC72C41),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: const Row(

                      children: [
                        SizedBox(width: 48,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Oh Snap !",style: TextStyle(
                                fontFamily: 'Muller',
                                color: Colors.white,
                                fontSize: 18
                              ),
                              ),
                              SizedBox(height: 8,),
                              Text("Not Our Product",style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Muller',
                                fontSize: 12
                              ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                            ],
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      }

    }
  }
}