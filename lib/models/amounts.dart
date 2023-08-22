class Amounts{
  final dynamic amounts;
  final dynamic subcatname;
  Amounts({
    required this.amounts,
    required this.subcatname,
  });
  factory Amounts.fromJson(Map<String, dynamic> json){
    return Amounts(
      amounts: json['amounts'], 
      subcatname: json['subcatname'],
    );
  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    
    data[subcatname] = amounts[subcatname];
    print(data);
    return data;
  }
}