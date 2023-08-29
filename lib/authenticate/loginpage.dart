import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zelix_trade/authenticate/signup.dart';
import 'package:zelix_trade/screens/home.dart';
import 'package:zelix_trade/services/authservice.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  String error = '';
  final auth = AuthService();  
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      const Text ("Login", style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),),
                      const SizedBox(height: 20,),
                      Text("Login with your credentials",style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),),
                      const SizedBox(height: 30,)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40
                    ),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 const Text('Email',style:TextStyle(
                                   fontSize: 15,
                                   fontWeight: FontWeight.w400,
                                   color: Colors.black87
                                 ),),
                                 const SizedBox(height: 5,),
                                 TextFormField(
                                   decoration: InputDecoration(
                                     contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                                     enabledBorder: OutlineInputBorder(
                                       borderSide: BorderSide(
                                         color: Colors.grey.shade400,
                                       ),
                                     ),
                                     border: OutlineInputBorder(
                                       borderSide: BorderSide(color: Colors.grey.shade400)
                                     ),
                                   ),
                                   validator: (v)=> v==null || !v.contains('@') || !v.contains('.') ? 'Enter a valid email' : null,
                                   onChanged: (v){
                                     setState(() {
                                        email = v;
                                     });
                                    
                                   },
                                 ),
                                 const SizedBox(height: 30,)
                             
                               ],
                             ),
                          Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 const Text('Password',style:TextStyle(
                                   fontSize: 15,
                                   fontWeight: FontWeight.w400,
                                   color: Colors.black87
                                 ),),
                                 const SizedBox(height: 5,),
                                 TextFormField(
                                   obscureText: true,
                                   decoration: InputDecoration(
                                     contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                                     enabledBorder: OutlineInputBorder(
                                       borderSide: BorderSide(
                                         color: Colors.grey.shade400,
                                       ),
                                     ),
                                     border: OutlineInputBorder(
                                       borderSide: BorderSide(color: Colors.grey.shade400)
                                     ),
                                   ),
                                   validator: (v)=> v==null || v.length<6 ? 'Enter a valid 6+ chars password' : null,
                                   onChanged: (v){
                                     setState(() {
                                        password = v;
                                     });
                                    
                                   },
                                 ),
                                 const SizedBox(height: 30,)
                             
                               ],
                             ),
                             Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(child: 
                                        Text(error,style: const TextStyle(fontSize: 16,color: Colors.red),)
                                    ),
                                   )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: const EdgeInsets.only(top: 3,left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: const [BoxShadow(blurRadius: 10,offset: Offset(-4, -2),color: Colors.black)],
                          border: const Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black)
                          )
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height:70,
                        onPressed: ()async{
                          if(_formkey.currentState!.validate()){
                           // dynamic result = auth.signInWithEmailAndPassword(email, password);
                           //     if(result == null){
                           //       setState(() {
                           //         error = 'Check your credentials!';
                           //       });
                           //     }
                           //     else{
                           //      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Home()));
                           //     }
                           await Supabase.instance.client.auth.signInWithOtp(email: email);
                           //if(result == null){
                           //   setState(() {
                           //     error = 'Check your credentials!';
                           //   });
                           //   const CircularProgressIndicator(
                           //     color: Colors.red,
                           //     strokeWidth: 10,
                           //   );
                           // }
                           // else{
                            await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Home()));
                          // }
                          }
                        },
                        color: const Color.fromARGB(255, 17, 199, 219),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: const Text("Login",style: TextStyle(
                          fontWeight: FontWeight.w600,fontSize: 26,color: Colors.white
                        ),),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Dont have an account?"),
                      GestureDetector(
                        onTap: ()=>Navigator.pushReplacement(context, 
                            MaterialPageRoute(builder: (context)=>const SignupPage())),
                        child: const Text("Sign Up",style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                        ),),
                      ),
                    ],
                  )
                ],
      
              ),
            ],
          ),
        ),
      ),
    );
  }
}
