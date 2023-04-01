import 'dart:convert';

AppData appDataFromJson(String str) => AppData.fromJson(json.decode(str));

String appDataToJson(AppData data) => json.encode(data.toJson());

class AppData {
  AppData({
    this.id = "",
    required this.name,
    required this.gender,
    required this.dob,
    required this.phone,
    required this.address,
  });

  String id;
  String name;
  String gender;
  String dob;
  String phone;
  String address;

  factory AppData.fromJson(Map<String, dynamic> json) => AppData(
        id: json["id"],
        name: json["name"],
        gender: json["gender"],
        dob: json["dob"],
        phone: json["phone"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "gender": gender,
        "dob": dob,
        "phone": phone,
        "address": address,
      };
}
