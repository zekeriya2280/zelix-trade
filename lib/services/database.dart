import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zelix_trade/models/Item.dart';
import 'package:zelix_trade/models/categories.dart';

class DatabaseService{
   DatabaseService();

  final CollectionReference<Map<String, dynamic>> usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference<Map<String, dynamic>> productionsCollection = FirebaseFirestore.instance.collection('productions');
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> setUserData(String name,String email,String password)async{
    
      await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
        'name':name,
        'email':email,
        'password':password,
      });
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> setNickname(String nickname)async{
    
      await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
        'nickname':nickname,
        'products':{}
      });
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> addNewTopTab(String categoryname,String subcatname,String name,String price,String amount,String incdec,String percent)async{
      await productionsCollection.doc('bzlfiLcEKnSM8TRpoxb8').update({
        categoryname : {
          subcatname : {
          'name' :name,
          'price':price,
          'amount':amount,
          'incdec':incdec,
          'percent':percent,
          }
        }
      });
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> addNewTopTabToME(String categoryname,String subcatname,String name,String price,String amount,String incdec,String percent)async{
      await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
        categoryname : [{
          subcatname : {
          'name' :name,
          'price':price,
          'amount':amount,
          'incdec':incdec,
          'percent':percent,
          }
        }]
      });
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> addNewItemGivenCatagoryToAllProducts(String categoryname,String subcatname,String name,String price,String amount,String incdec,String percent)async{
      DocumentSnapshot<Map<String, dynamic>> temp = await productionsCollection.doc('bzlfiLcEKnSM8TRpoxb8').get();
      List<Categories> cats = [];
      List<Item> items = [];
      List<Map<String,dynamic>> maps = [];
      final data = temp.data()![categoryname];
     
      for (var i = 0; i < data.length; i++) {
        //print(data[i]);
        cats.add(Categories.fromJson(data[i].keys.first));
        items.add(Item.fromJson(data[i],data[i].keys.first));
      }
      for (var i = 0; i < cats.length; i++) {
        maps.add({cats[i].submap : items[i].toJson()});
      }
      maps.add({subcatname : {'name' :name,'price':price,'amount':amount,'incdec':incdec,'percent':percent}});
      await productionsCollection.doc('bzlfiLcEKnSM8TRpoxb8').update({categoryname:maps});
  }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> addNewItemGivenCatagoryToMyProducts(String categoryname,String subcatname,String name,String price,String incdec,String percent)async{
      DocumentSnapshot<Map<String, dynamic>> temp = await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
      List<Categories> cats = [];
      List<Item> items = [];
      List<Map<String,dynamic>> maps = [];
      Map<String, dynamic> tempamounts = <String,dynamic>{};
      final data = temp.data()![categoryname];
      final amounts = temp.data()!['amounts'];
      final amount = temp.data()!['amounts'][subcatname];
      tempamounts = amounts;
      tempamounts.addAll({subcatname:  1});
      print(tempamounts);
      if(data == null){
        addNewTopTabToME(categoryname,subcatname,name,price,amount ?? "1",incdec,percent);
        await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({'amounts':tempamounts});
      }
      
      for (var i = 0; i < data.length; i++) {
        cats.add(Categories.fromJson(data[i].keys.first));
        items.add(Item.fromJson(data[i],data[i].keys.first));
      }
      for (var i = 0; i < cats.length; i++) {
        maps.add({cats[i].submap : items[i].toJson()});
      }
      for (var i = 0; i < temp.data()![categoryname].length; i++) {
          if(List<Map<String,dynamic>>.from(temp.data()![categoryname]).every((itemmap)=>itemmap.keys.first != subcatname)){
              maps.add({subcatname : {'name' :name,'price':price,'amount':amount,'incdec':incdec,'percent':percent}});
          } 
          else{
            for (var map in maps) {
              if(map.keys.first != subcatname){
                maps[maps.indexOf(map)] = {subcatname : {'name' :name,'price':price,'amount':(amount+1).toString(),'incdec':incdec,'percent':percent}};
              }
            }
            await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({'amounts':tempamounts});
          }
      }
      await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({categoryname:maps});
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    Future<List<Map<String, dynamic>>> getFromFirebaseCategories(String categoryname)async{
      DocumentSnapshot<Map<String, dynamic>> temp = await productionsCollection.doc('bzlfiLcEKnSM8TRpoxb8').get();
      List<Categories> cats = [];
      List<Item> items = [];
      List<Map<String,dynamic>> maps = [];
      final data = temp.data()![categoryname];
      for (var i = 0; i < data.length; i++) {
        cats.add(Categories.fromJson(data[i].keys.first.toString()));
        items.add(Item.fromJson(data[i],data[i].keys.first.toString()));
      }
      for (var i = 0; i < cats.length; i++) {
        maps.add({cats[i].submap : items[i].toJson()});
      }
      return maps;
  }
  Future<List<Map<String, dynamic>>> getFromFirebaseCategoriesOfMY(String categoryname)async{
      DocumentSnapshot<Map<String, dynamic>> temp = await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
      List<Categories> cats = [];
      List<Item> items = [];
      List<Map<String,dynamic>> maps = [];
      final data = temp.data()![categoryname];
      for (var i = 0; i < data.length; i++) {
        cats.add(Categories.fromJson(data[i].keys.first.toString()));
        items.add(Item.fromJsonMY(data[i],data[i].keys.first.toString()));
      }
      for (var i = 0; i < cats.length; i++) {
        maps.add({cats[i].submap : items[i].toJson()});
      }
      return maps;
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<int> amountFinderForMyProductsItems(String subcatname)async{
      DocumentSnapshot<Map<String, dynamic>> temp = await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
      return temp.data()!['amounts'][subcatname];
  }
}
