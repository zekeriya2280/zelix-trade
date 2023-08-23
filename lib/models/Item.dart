class Item{
  String name = "";
  String price = "";
  String amount = "";
  String incdec = "";
  String percent = "";
  Item({required this.name, required this.price, required this.amount, required this.incdec, required this.percent});  

  factory Item.fromJson(Map<String, dynamic> json,String subname){
    return Item(
      name: json[subname]['name'],
      price: json[subname]['price'],
      amount: json[subname]['amount'],
      incdec: json[subname]['incdec'],
      percent: json[subname]['percent'],
    );
  }
   factory Item.fromJsonAmountZero(dynamic subname){
    return Item(
      name: subname['name'],
      price: subname['price'],
      amount: subname['amount'],
      incdec: subname['incdec'],
      percent: subname['percent'],
    );
  }
   factory Item.fromJsonAllDEC(Map<String, dynamic> json,String subname,String subcatname){ //BUYING FROM ALLPRODUCTS
    if(json[subname]['name'] == subcatname){
      if(int.parse(json[subname]['amount']) > 0){json[subname]['amount'] = (int.parse(json[subname]['amount']) - 1).toString();}
      json[subname]['percent'] = (double.parse(json[subname]['percent']) + 0.5).toString();
      json[subname]['incdec'] = 'inc';
      return Item(
        name: json[subname]['name'],
        price: json[subname]['price'],
        amount: json[subname]['amount'],
        incdec: json[subname]['incdec'],
        percent: json[subname]['percent'],
      );
    }
    else{
      return Item(
        name: json[subname]['name'],
        price: json[subname]['price'],
        amount: json[subname]['amount'],
        incdec: json[subname]['incdec'],
        percent: json[subname]['percent'],
      );
    }
  }
  factory Item.fromJsonAllINC(Map<String, dynamic> json,String subname,String subcatname,int subcatnameamountpref){
    if(json[subname]['name'] == subcatname){
      if(subcatnameamountpref > 0){json[subname]['amount'] = (int.parse(json[subname]['amount']) + 1).toString();}
      return Item(
        name: json[subname]['name'],
        price: json[subname]['price'],
        amount: json[subname]['amount'],
        incdec: json[subname]['incdec'],
        percent: json[subname]['percent'],
      );
    }
    else{
      return Item(
        name: json[subname]['name'],
        price: json[subname]['price'],
        amount: json[subname]['amount'],
        incdec: json[subname]['incdec'],
        percent: json[subname]['percent'],
      );
    }
  }
  factory Item.fromJsonMY(Map<String, dynamic> json,String subname,String amount,String subcatname,String percent){ //BUYING FROM ALLPRODUCTS
  if(json[subname]['name'] == subcatname){
    //json[subname]['percent'] = (double.parse(json[subname]['percent']) + 0.5).toString();
    json[subname]['incdec'] = 'inc';
    return Item(
      name: json[subname]['name'],
      price: json[subname]['price'],
      amount: amount,
      incdec: json[subname]['incdec'],
      percent: percent,
    );
  }else{
    return Item(
      name: json[subname]['name'],
      price: json[subname]['price'],
      amount: amount,
      incdec: json[subname]['incdec'],
      percent: json[subname]['percent'],
    );

  }
    
    
  }
  Map<String,dynamic> toJson(){
    Map<String,dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    data['amount'] = amount;
    data['incdec'] = incdec;
    data['percent'] = percent;
    return data;
  }
}