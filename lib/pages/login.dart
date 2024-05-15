import 'package:flutter/material.dart';
import 'package:autocart/pages/barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


// String user = userNameController.text;
// await FirebaseFirestore.instance.collection(user).add({"name": user,"age": passwordController.text});
// await FirebaseFirestore.instance.collection(user).get().then((event) {
//   for (var doc in event.docs) {
//     print("${doc.id} => ${doc.data()}");




class Login extends StatefulWidget {
  final List<List<dynamic>> items;
  const Login({super.key,required this.items});

  @override
  State<Login> createState() => _LoginState(items);
}

class _LoginState extends State<Login> {
  late final List<List<dynamic>> items;

  _LoginState(this.items);
  login() async {
    String enteredUsername = userNameController.text;
    String user;
    if(enteredUsername == 'cart1' || enteredUsername == 'cart2'){
      user = enteredUsername;
      if(passwordController.text == '123'){
        print("Valid👍");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInUser', user);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Scanner_B(user: user,items: items,)));
      }
      else
      {
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
                                  fontSize: 14
                              ),
                              ),
                              SizedBox(height: 6,),
                              Text("Please Enter Correct Password",style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Muller',
                                  fontSize: 8
                              ),
                                maxLines: 4,
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
    else{
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
                                fontSize: 14
                            ),
                            ),
                            SizedBox(height: 6,),
                            Text("Please Enter Correct Username Or Password",style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Muller',
                                fontSize: 8
                            ),
                              maxLines: 4,
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
    print(userNameController.text);
    print(passwordController.text);
  }
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
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
      body:Center(
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
      ),
      backgroundColor: Colors.black,
    );
  }
}

