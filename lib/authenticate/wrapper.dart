import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zelix_trade/authenticate/loginpage.dart';
import 'package:zelix_trade/screens/Intro.dart';
import 'package:zelix_trade/screens/home.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final CollectionReference<Map<String, dynamic>> users  = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: users.snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){return const Center(child: CircularProgressIndicator(strokeWidth: 10,color: Colors.green,));}
                return snapshot.data!.docs.any((doc){
                  //print('nickname: ${FirebaseAuth.instance.currentUser!.uid}');
                  return doc.data()['nickname'] == null && FirebaseAuth.instance.currentUser!.uid == doc.id;}) ? 
                    const IntroPage() 
                    : 
                    const Home();
              }
            );
          }
          else{
            return const LoginPage();
          }
        }),
    );
  }
}