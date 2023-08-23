
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      });
  }
  ////////////////////////////////////////////////////////ADD NEW CATEGORY TO ALL PRODUCTS //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
  ////////////////////////////////////////////////////////ADD NEW CATEGORY TO MY PRODUCTS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
  ////////////////////////////////////////////////////////// ADD NEW ITEM TO ALL PRODUCTS //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////// ALLPRODUCTS TO MYPRODUCTS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> addNewItemGivenCatagoryToMyProducts(String categoryname,String subcatname,String name,String price,String incdec,String percent)async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.clear();
      //print(categoryname);
      DocumentSnapshot<Map<String, dynamic>> users = await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
      DocumentSnapshot<Map<String, dynamic>> productions = await productionsCollection.doc('bzlfiLcEKnSM8TRpoxb8').get();
      List<Categories> cats = [];
      List<Item> items = [];
      List<Categories> catspro = [];
      List<Item> itemspro = [];
      List<Map<String,dynamic>> maps = [];
      List<Map<String,dynamic>> mapsPro = [];
      final data = users.data()![categoryname];
      final products = productions.data()![categoryname];
      if(data == null){// CATEGORYNAME NOT EXISTS
      //print('dddddd');
        await addNewTopTabToME(categoryname,subcatname,name,price,'1',incdec,percent); //NEW CATEGORY ADDED WITH CATEGORYNAME ABOVE TO MYPRODUCTS
        prefs.setString('${subcatname}amount', '1');
      }
      ///////////////////////////////////////////////ALLPRODUCTS TO MAPSPRO//////////////////////////////////////////////
      for (var i = 0; i < products.length; i++) {//DIVIDES ALL ITEMS INTO CATEGORIES CLASS TO ITEM CLASS.
        catspro.add(Categories.fromJson(products[i].keys.first));
        itemspro.add(Item.fromJsonAllDEC(products[i],products[i].keys.first,subcatname));//DECREASE AMOUNT BY 1
      }
      for (var i = 0; i < catspro.length; i++) {//GET TOGETHER ALL ITEMS TO MAPS.
        mapsPro.add({catspro[i].submap : itemspro[i].toJson()});
      }
      //print(mapsPro);
      ///////////////////////////////////////////////MYPRODUCTS TO MAPS//////////////////////////////////////////////
      for (var i = 0; i < data.length; i++) {//DIVIDES ALL ITEMS INTO CATEGORIES CLASS TO ITEM CLASS.
        cats.add(Categories.fromJson(data[i].keys.first));
        items.add(Item.fromJsonMY(data[i],data[i].keys.first,prefs.getString(data[i].keys.first+'amount') ?? '1'));
      }
      for (var i = 0; i < cats.length; i++) {//GET TOGETHER ALL ITEMS TO MAPS.
        maps.add({cats[i].submap : items[i].toJson()});
      }
      await prefs.setString('${subcatname}amount', (int.parse(prefs.getString('${subcatname}amount') ?? '0')+1).toString());//WHEN BOUGHT FROM ALLPRODUCTS TO MYPRODUCTS THE AMOUNT OF MYPRODUCTS ITEM AMOUNT INCREASE BY 1 

      if(mapsPro.any((map) => int.parse(Item.fromJsonAmountZero(map.values.first).amount) < 1  && Item.fromJsonAmountZero(map.values.first).name == subcatname)){//ALLPROCTS ITEM THAT TRYING TO BUY IS LESS THAN 1 MYPRODUCTS ITEM
         await prefs.setString('${subcatname}amount', (int.parse(prefs.getString('${subcatname}amount') ?? '0')-1).toString());                                  //INCREASE AMOUNT OF MYPRODUCTS ITEM CANCELED BY DECREASING AMOUNT
      }                                                                                                                                                          //BY 1.
      else{//IF ITEM STILL EXISTS IN ALLPROCTS, ADDING amount TO MYPRODUCTS item by 1
        if(List<Map<String,dynamic>>.from(data).every((itemmap)=>itemmap.keys.first != subcatname)){//ONLY NAME MATCHED WITH MYPRODUCTS AMOUNT WILL BE INCREASED
            //print('itemmap.keys.first : '+ data[data.length-1].keys.first.toString() + ' subcatname : ' + subcatname);
              maps.add({subcatname : {'name' :name,'price':price,'amount':'1','incdec':incdec,'percent':percent}});
              prefs.setString('${subcatname}amount', '1');
          } 
          else{
                for (var map in maps) {
                  if(map.keys.first == subcatname){
                    maps[maps.indexOf(map)] = {subcatname : {'name' :name,'price':price,'amount':prefs.getString('${subcatname}amount') ?? '1','incdec':incdec,'percent':percent}};
                  }
                }
          }
       
      }
      await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({categoryname:maps}); //ALL ITEMS BEFORE AND NEW ADDED TO MAPS AND UPDATE USERS CATEGORY
      await productionsCollection.doc('bzlfiLcEKnSM8TRpoxb8').update({categoryname:mapsPro}); //ALL ITEMS BEFORE AND NEW ADDED TO MAPS AND UPDATE USERS CATEGORY
  }
  ////////////////////////////////////////////////////////////// ALLPRODUCTS TO MYPRODUCTS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> sellItemGivenCatagoryToAllProducts(String categoryname,String subcatname,String name,String price,String incdec,String percent)async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.clear();
      //print(categoryname);
      DocumentSnapshot<Map<String, dynamic>> users = await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
      DocumentSnapshot<Map<String, dynamic>> productions = await productionsCollection.doc('bzlfiLcEKnSM8TRpoxb8').get();
      List<Categories> cats = [];
      List<Item> items = [];
      List<Categories> catspro = [];
      List<Item> itemspro = [];
      List<Map<String,dynamic>> maps = [];
      List<Map<String,dynamic>> mapsPro = [];
      final data = users.data()![categoryname];
      final products = productions.data()![categoryname];
    // if(data == null){// CATEGORYNAME NOT EXISTS
    // //print('dddddd');
    //   await addNewTopTabToME(categoryname,subcatname,name,price,'1',incdec,percent); //NEW CATEGORY ADDED WITH CATEGORYNAME ABOVE TO MYPRODUCTS
    //   prefs.setString('${subcatname}amount', '1');
    // }
      ///////////////////////////////////////////////ALLPRODUCTS TO MAPSPRO//////////////////////////////////////////////
      for (var i = 0; i < products.length; i++) {//DIVIDES ALL ITEMS INTO CATEGORIES CLASS TO ITEM CLASS.
        catspro.add(Categories.fromJson(products[i].keys.first));
        itemspro.add(Item.fromJsonAllINC(products[i],products[i].keys.first,subcatname));//INCREASE AMOUNT BY 1
      }
      for (var i = 0; i < catspro.length; i++) {//GET TOGETHER ALL ITEMS TO MAPS.
        mapsPro.add({catspro[i].submap : itemspro[i].toJson()});
      }
      //print(mapsPro);
      ///////////////////////////////////////////////MYPRODUCTS TO MAPS//////////////////////////////////////////////
      for (var i = 0; i < data.length; i++) {//DIVIDES ALL ITEMS INTO CATEGORIES CLASS TO ITEM CLASS.
        cats.add(Categories.fromJson(data[i].keys.first));
        items.add(Item.fromJsonMY(data[i],data[i].keys.first,prefs.getString(data[i].keys.first+'amount') ?? '1'));
      }
      for (var i = 0; i < cats.length; i++) {//GET TOGETHER ALL ITEMS TO MAPS.
        maps.add({cats[i].submap : items[i].toJson()});
      }
      await prefs.setString('${subcatname}amount', (int.parse(prefs.getString('${subcatname}amount') ?? '0')-1).toString());//WHEN BOUGHT FROM ALLPRODUCTS TO MYPRODUCTS THE AMOUNT OF MYPRODUCTS ITEM AMOUNT INCREASE BY 1 

      if(maps.any((map) => int.parse(Item.fromJsonAmountZero(map.values.first).amount) < 1  && Item.fromJsonAmountZero(map.values.first).name == subcatname)){//ALLPROCTS ITEM THAT TRYING TO SELL IS LESS THAN 1
         await prefs.setString('${subcatname}amount', (int.parse(prefs.getString('${subcatname}amount') ?? '0')+1).toString());                                  //DECREASE AMOUNT OF MYPRODUCTS ITEM CANCELED BY INCREASING AMOUNT
      }                                                                                                                                                          //BY 1.
      else{//IF ITEM STILL EXISTS IN ALLPROCTS, ADDING amount TO MYPRODUCTS item by 1
        if(List<Map<String,dynamic>>.from(data).every((itemmap)=>itemmap.keys.first != subcatname)){//ONLY NAME MATCHED WITH MYPRODUCTS AMOUNT WILL BE INCREASED
           // //print('itemmap.keys.first : '+ data[data.length-1].keys.first.toString() + ' subcatname : ' + subcatname);
           //   maps.add({subcatname : {'name' :name,'price':price,'amount':'1','incdec':incdec,'percent':percent}});
           //   prefs.setString('${subcatname}amount', '1');
          } 
          else{
                for (var map in maps) {
                  if(map.keys.first == subcatname){
                    maps[maps.indexOf(map)] = {subcatname : {'name' :name,'price':price,'amount':prefs.getString('${subcatname}amount') ?? '1','incdec':incdec,'percent':percent}};
                  }
                }
          }
       
      }
      await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({categoryname:maps}); //ALL ITEMS BEFORE AND NEW ADDED TO MAPS AND UPDATE USERS CATEGORY
      await productionsCollection.doc('bzlfiLcEKnSM8TRpoxb8').update({categoryname:mapsPro}); //ALL ITEMS BEFORE AND NEW ADDED TO MAPS AND UPDATE USERS CATEGORY
  }
  //////////////////////////////////////////////////////////////SHOWING IN THE ALL LISTVIEW////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////SHOWING IN THE MY LISTVIEW////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> getFromFirebaseCategoriesOfMY(String categoryname)async{
      DocumentSnapshot<Map<String, dynamic>> temp = await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
      List<Categories> cats = [];
      List<Item> items = [];
      List<Map<String,dynamic>> maps = [];
      final data = temp.data()![categoryname];
      if(data == null){return [];}
      for (var i = 0; i < data.length; i++) {
        cats.add(Categories.fromJson(data[i].keys.first.toString()));
        items.add(Item.fromJson(data[i],data[i].keys.first.toString()));
      }
      for (var i = 0; i < cats.length; i++) {
        maps.add({cats[i].submap : items[i].toJson()});
      }
      return maps;
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
