import 'package:flutter/material.dart';
import 'package:autocart/pages/barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent,
        centerTitle: true,
        title: Text("AutoCart",style: TextStyle(
            fontFamily: 'Battery',
            fontWeight: FontWeight.bold
        ),),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 24),
      ),
      body: login2(),
      backgroundColor: Colors.black,
    );
  }
}

class login2 extends StatefulWidget {
  login2({super.key});

  @override
  State<login2> createState() => _login2State();
}

class _login2State extends State<login2> {
  sent_val() async
  {
    String user = userNameController.text;
    // await FirebaseFirestore.instance.collection(user).add({"name": user,"age": passwordController.text});
    // await FirebaseFirestore.instance.collection(user).get().then((event) {
    //   for (var doc in event.docs) {
    //     print("${doc.id} => ${doc.data()}");
    //   }
    // });
    print("Data sent");
  }
  login(){
    if(userNameController.text == 'cart1' || userNameController.text == 'cart2' && passwordController.text == '123'){
      sent_val();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Scanner_B(user: userNameController.text,)));
    }
    else{
      print("Invalid");
    }
    print(userNameController.text);
    print(passwordController.text);
  }
  final userNameController = TextEditingController();

  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.9,
              child: Column(
                children: [
                  Text("CART",style: TextStyle(fontSize: 28,fontFamily: 'Muller'),),
                  TextFormField(
                    validator: (value){

                    },
                    controller: userNameController,
                    decoration: InputDecoration(

                        hintText: 'Cart Code',


                        hintStyle: TextStyle(color: Colors.blueGrey,),
                        border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 15,),

                  TextFormField(
                    validator: (value){

                    },
                    controller: passwordController,
                    decoration: InputDecoration(
                        hintText: 'Key',
                        hintStyle: TextStyle(color: Colors.blueGrey),
                        border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 8,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    onPressed: login,
                    child: Text(
                        "ACTIVATE",
                        style: TextStyle(
                            fontSize: 30,
                          fontFamily: 'Muller',
                          color: Colors.lightGreenAccent
                        )
                    ),
                  ),
                ],
              ),
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.lightGreenAccent,borderRadius: BorderRadius.circular(10)),
            ),
          ],
        ),
      ),
    );
  }
}