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
        'totalmoney':'5000'
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
  Future<void> addNewItemGivenCatagoryToMyProducts(String categoryname,String subcatname,String name,String price,String incdec,String percent)async{//     BUYING
      DocumentSnapshot<Map<String, dynamic>> users = await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
      DocumentSnapshot<Map<String, dynamic>> productions = await productionsCollection.doc('bzlfiLcEKnSM8TRpoxb8').get();
      List<Map<String,dynamic>> maps = [];
      List<Map<String,dynamic>> mapsPro = [];
      final data = users.data()![categoryname];
      final products = productions.data()![categoryname];
      if(data == null){// CATEGORYNAME NOT EXISTS
        await addNewTopTabToME(categoryname,subcatname,name,price,'1',incdec,percent); //NEW CATEGORY ADDED WITH CATEGORYNAME ABOVE TO MYPRODUCTS
      }
      ///////////////////////////////////////////////ALLPRODUCTS TO MAPSPRO//////////////////////////////////////////////
      for (var i = 0; i < products.length; i++) {//DIVIDES ALL ITEMS INTO CATEGORIES CLASS TO ITEM CLASS.
        if(products[i].keys.first == subcatname){
          await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({'totalmoney': (int.parse(users.data()!['totalmoney']) - (int.parse(products[i].values.first['price']))).toString()});
          products[i].values.first['price']=  ((double.parse(products[i].values.first['price']) + ((double.parse(products[i].values.first['price']) * double.parse(products[i].values.first['percent']))/100)).floor()).toString();
          products[i].values.first['amount'] = (int.parse(products[i].values.first['amount']) - 1).toString();
          products[i].values.first['percent'] = (double.parse(products[i].values.first['percent']) + 0.5).toString();
          products[i].values.first['incdec'] = 'inc';
          mapsPro.add({products[i].keys.first : products[i].values.first});
        }
        else{
          mapsPro.add({products[i].keys.first : products[i].values.first});
        }
      }
      for (var i = 0; i < data.length; i++) {//DIVIDES ALL ITEMS INTO CATEGORIES CLASS TO ITEM CLASS.
        if(data[i].keys.first == subcatname){
          maps.add({data[i].keys.first : data[i].values.first});
        }
        else{
          maps.add({data[i].keys.first : data[i].values.first});
        }
      }
      if(mapsPro.any((map) => int.parse(Map<String,dynamic>.from(map.values.first)['amount']) < 1  && Map<String,dynamic>.from(map.values.first)['name'] == subcatname)){//ALLPROCTS ITEM THAT TRYING TO BUY IS LESS THAN 1 MYPRODUCTS ITEM                                //INCREASE AMOUNT OF MYPRODUCTS ITEM CANCELED BY DECREASING AMOUNT
      }                                                                                                                                                          //BY 1.
      else{//IF ITEM STILL EXISTS IN ALLPROCTS, ADDING amount TO MYPRODUCTS item by 1
        if(List<Map<String,dynamic>>.from(data).every((itemmap)=>itemmap.keys.first != subcatname)){//ONLY NAME MATCHED WITH MYPRODUCTS AMOUNT WILL BE INCREASED
              maps.add({subcatname : {'name' :name,'price':price,'amount':'1','incdec':incdec,'percent':(double.parse(percent)+0.5).toString()}});
          } 
          else{//IF ITEM ALREADY EXIST IN MYPRODUCTS
                for (var map in maps) {
                  if(map.keys.first == subcatname){
                    maps[maps.indexOf(map)] = {subcatname : 
                                                  {'name' :name,
                                                   'price':((double.parse(price) + ((double.parse(price) * double.parse(percent))/100)).floor()).toString(),
                                                   'amount':(int.parse(maps[maps.indexOf(map)].values.first['amount']) + 1).toString(),
                                                   'incdec':'inc',
                                                   'percent':(double.parse(percent)+0.5).toString()}};
                  }
                }
          }
      }
      await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({categoryname:maps}); //ALL ITEMS BEFORE AND NEW ADDED TO MAPS AND UPDATE USERS CATEGORY
      await productionsCollection.doc('bzlfiLcEKnSM8TRpoxb8').update({categoryname:mapsPro}); //ALL ITEMS BEFORE AND NEW ADDED TO MAPS AND UPDATE USERS CATEGORY
  }
  ////////////////////////////////////////////////////////////// ALLPRODUCTS TO MYPRODUCTS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> sellItemGivenCatagoryToAllProducts (String categoryname,String subcatname,String name,String price,String incdec,String percent)async{//     BUYING
      DocumentSnapshot<Map<String, dynamic>> users = await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
      DocumentSnapshot<Map<String, dynamic>> productions = await productionsCollection.doc('bzlfiLcEKnSM8TRpoxb8').get();
      List<Map<String,dynamic>> maps = [];
      List<Map<String,dynamic>> mapsPro = [];
      final data = users.data()![categoryname];
      final products = productions.data()![categoryname];
      //if(data == null){// CATEGORYNAME NOT EXISTS
      //  await addNewTopTabToME(categoryname,subcatname,name,price,'1',incdec,percent); //NEW CATEGORY ADDED WITH CATEGORYNAME ABOVE TO MYPRODUCTS
      //}
      ///////////////////////////////////////////////ALLPRODUCTS TO MAPSPRO//////////////////////////////////////////////
      for (var i = 0; i < products.length; i++) {//DIVIDES ALL ITEMS INTO CATEGORIES CLASS TO ITEM CLASS.
        if(products[i].keys.first == subcatname){
          await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({'totalmoney': (int.parse(users.data()!['totalmoney']) + (int.parse(products[i].values.first['price']))).toString()});
          products[i].values.first['price']=  ((double.parse(products[i].values.first['price']) - ((double.parse(products[i].values.first['price']) * double.parse(products[i].values.first['percent']))/100)).floor()).toString();
          products[i].values.first['amount'] = (int.parse(products[i].values.first['amount']) + 1).toString();
          products[i].values.first['percent'] = (double.parse(products[i].values.first['percent']) - 0.5).toString();
          products[i].values.first['incdec'] = 'dec';
          mapsPro.add({products[i].keys.first : products[i].values.first});
        }
        else{
          mapsPro.add({products[i].keys.first : products[i].values.first});
        }
      }
      for (var i = 0; i < data.length; i++) {//DIVIDES ALL ITEMS INTO CATEGORIES CLASS TO ITEM CLASS.
        if(data[i].keys.first == subcatname){
          maps.add({data[i].keys.first : data[i].values.first});
        }
        else{
          maps.add({data[i].keys.first : data[i].values.first});
        }
      }
      if(maps.any((map) => int.parse(Map<String,dynamic>.from(map.values.first)['amount']) < 1  && Map<String,dynamic>.from(map.values.first)['name'] == subcatname)){//ALLPROCTS ITEM THAT TRYING TO BUY IS LESS THAN 1 MYPRODUCTS ITEM                                //INCREASE AMOUNT OF MYPRODUCTS ITEM CANCELED BY DECREASING AMOUNT
      }                                                                                                                                                          //BY 1.
      else{//IF ITEM STILL EXISTS IN ALLPROCTS, ADDING amount TO MYPRODUCTS item by 1
       for (var map in maps) {
                  if(map.keys.first == subcatname){
                    maps[maps.indexOf(map)] = {subcatname : 
                                                  {'name' :name,
                                                   'price':((double.parse(price) - ((double.parse(price) * double.parse(percent))/100)).floor()).toString(),
                                                   'amount':(int.parse(maps[maps.indexOf(map)].values.first['amount']) - 1).toString(),
                                                   'incdec':'dec',
                                                   'percent':(double.parse(percent)-0.5).toString()}};
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
      for (var i = 0; i < data.length; i++) {//DIVIDES ALL ITEMS INTO CATEGORIES CLASS TO ITEM CLASS.
        //if(data[i].keys.first == subcatname){
        //  data[i].values.first['amount'] = (int.parse(data[i].values.first['amount']) + 1).toString();
        //  maps.add({data[i].keys.first : data[i].values.first});
        //  //Map<String,dynamic>.from(products[i]).foreach((v){v.values.first['amount'] -= 1;return v;});
        //  //mapsPro.add(products[i].map((v){v.values.first['amount'] -= 1;return v;}));
        //}
        //else{
          maps.add({data[i].keys.first : data[i].values.first});
        //}
        print(maps);
       //catspro.add(Categories.fromJson(products[i].keys.first));
       //itemspro.add(Item(amount: prefs.getString('${subcatname}amount') ?? '1',percent: percent,incdec: incdec,name: subcatname,price: price).fromJsonAllDEC(products[i],products[i].keys.first,subcatname));//DECREASE AMOUNT BY 1
      }
      return maps;
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
