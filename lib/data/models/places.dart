class Places{

  late String placeId;
late String description;
Places.fromJson(Map <String,dynamic>json){
  placeId=json['place_id'];
  description=json['description'];
}
}