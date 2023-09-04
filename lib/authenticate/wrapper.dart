import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zelix_trade/authenticate/loginpage.dart';
import 'package:zelix_trade/screens/home.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}
class _WrapperState extends State<Wrapper> {
  final supabase = Supabase.instance.client;
  //final CollectionReference<Map<String, dynamic>> users  = FirebaseFirestore.instance.collection('users');
  Widget _redirect(AuthState? data) {
    //final session = supabase.auth.currentUser;
    //print(data);
    if (data != null && data.event != AuthChangeEvent.signedOut) {
      return const Home();
    } else {
      return const LoginPage();
    }
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        //if(!snapshot.hasData){return CircularProgressIndicator(strokeWidth: 10,color: Colors.green,);}
        //print(snapshot.data);
        return _redirect(snapshot.data);
      }
    );
  }
}