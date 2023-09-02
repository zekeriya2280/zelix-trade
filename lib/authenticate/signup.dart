import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zelix_trade/authenticate/loginpage.dart';
import 'package:zelix_trade/screens/Intro.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String name = '';
  String email = '';
  String password = '';
  String error = ''; 
  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text ("Sign up", style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),),
                          const SizedBox(height: 20,),
                          Text("Create an Account",style: TextStyle(
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
                                     const Text('Name',style:TextStyle(
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
                                       validator: (v)=> v==null || v.length<6 ? 'Enter a valid 6+ chars name' : null,
                                       onChanged: (v){
                                        setState(() {
                                           name = v;
                                        });
                                        
                                       },
                                     ),
                                     const SizedBox(height: 30,)
      
                                   ],
                              ),
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
                            boxShadow: const [BoxShadow(blurRadius: 10,offset: Offset(-4, -2),color: Colors.black)],
                              borderRadius: BorderRadius.circular(40),
                              border: const Border(
                                  bottom: BorderSide(color: Colors.black),
                                  top: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black)
                              )
                          ),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height:60,
                            onPressed: ()async{
                              if(_formkey.currentState!.validate()){
                               // dynamic result = await auth.registerWithEmailAndPassword(name, email, password);
                               // if(result == null){
                               //   setState(() {
                               //     error = 'Check your credentials!';
                               //   });
                               //   const CircularProgressIndicator(
                               //     color: Colors.red,
                               //     strokeWidth: 10,
                               //   );
                               // }
                               // else{
                               //  await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const IntroPage()));
                               // }

                              AuthResponse result = await Supabase.instance.client.auth.signUp(email: email, password: password);
                                if(result == null){
                                   setState(() {
                                     error = 'Check your credentials!';
                                   });
                                   const CircularProgressIndicator(
                                     color: Colors.red,
                                     strokeWidth: 10,
                                   );
                                 }
                                 else{
                                 await Supabase.instance.client.auth.updateUser(UserAttributes(data: {'password': password}));
                                 await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const IntroPage()));
                                }
                              }
                            },
                            color: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)
                            ),
                            child: const Text("Sign Up",style: TextStyle(
                              fontWeight: FontWeight.w600,fontSize: 26,color: Colors.white
      
                            ),),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: ()=>Navigator.pushReplacement(context, 
                            MaterialPageRoute(builder: (context)=>const LoginPage())),
                            child: const Text("Login",style: TextStyle(
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
        ),
      ),
    );
  }
}