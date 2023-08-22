class Categories{
  final String submap;

  Categories({
    required this.submap,
  });
  factory Categories.fromJson(String submap){
    return Categories(
      submap: submap,
    );
  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['submap'] = submap;
    return data;
  }
    
  
}