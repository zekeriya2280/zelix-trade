import 'package:firebase_auth/firebase_auth.dart';
import 'package:zelix_trade/models/user.dart';
import 'package:zelix_trade/services/database.dart';

class AuthService{
 
 final FirebaseAuth auth = FirebaseAuth.instance;

 //create user obj from FirebaseUser
 Userr userFromFirebaseUser(User? user){
   return user != null ? Userr(uid: user.uid) : Userr();
 }
 //
 Stream<Userr> get user{
  return auth.authStateChanges().map( userFromFirebaseUser);
 }
 //sign in anon:
 Future<Userr> signInAnon()async{
  try {
     UserCredential result = await auth.signInAnonymously();
     User? user = result.user;
     return userFromFirebaseUser(user);
  } catch (e) {
    print(e.toString());
    return Userr();
    
  }
 }
 //signoutanon
 Future signOut()async{
  try {
    return await auth.signOut();
  } catch (e) {
    print('CAN NOT SIGN OUT : $e');
    return;
  }
 }
Future signInWithEmailAndPassword(String email,String password)async{
  try {
    UserCredential result = await auth.signInWithEmailAndPassword(email: email,password: password);
    User? user = result.user;
     return userFromFirebaseUser(user);
     
  } catch (e) {
    print('can not signed in : $e');
    return null;
  }
 }
  Future registerWithEmailAndPassword(String name,String email,String password)async{
  try {
    UserCredential result = await auth.createUserWithEmailAndPassword(email: email,password: password);
    User? user = result.user;
    print(user);
     await DatabaseService().setUserData(name,email,password);
     print('B');
     return userFromFirebaseUser(user);
     
  } catch (e) {
    print('can not signed up : $e');
    return null;
  }
 }
 
}