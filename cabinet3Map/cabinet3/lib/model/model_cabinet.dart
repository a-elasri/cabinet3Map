class ModelCabinet{
  String id;
  String name;
  String adresse;
  String disponibilite;
  String image='https://images-prj.vercel.app/img/cabinet1.png';
  Map<String,String> coordinates;
  String service;

  ModelCabinet({required this.id,required this.name,required this.adresse,required this.disponibilite,
   required this.coordinates, required this.service});

  factory ModelCabinet.fromJson(Map<String, dynamic> json) {
    return ModelCabinet(
      id: json['id'],
      name: json['text'],
      adresse: json['properties']['address'],
      disponibilite: "ouvert",
      coordinates:toCoordinate(json['geometry']['coordinates']),
      //service: json['properties']['maki'],
      service: "",
    );
  }

  static Map<String,String> toCoordinate(dynamic coordinatesTable){
    return{
      "longitude":coordinatesTable[0].toString(),
      "latitude":coordinatesTable[1].toString()
    };
  }
@override
  String toString() {
    // TODO: implement toString
    return name;
  }
}