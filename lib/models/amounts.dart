class Amounts{
  final dynamic amounts;
  Amounts({
    required this.amounts,
  });
  factory Amounts.fromJson(Map<String, dynamic> json){
    return Amounts(
      amounts: json['amount'],
    );
  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    
    data['amount'] = amounts['amount'];
    print(data);
    return data;
  }
}