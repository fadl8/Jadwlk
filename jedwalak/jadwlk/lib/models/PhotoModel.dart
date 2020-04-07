// To parse this JSON data, do
//
//     final bGsModel = bGsModelFromJson(jsonString);

import 'dart:convert';

List<BGsModel> bGsModelFromJson(  str) => List<BGsModel>.from( (str).map((x) => BGsModel.fromMap(x)));

String bGsModelToJson(List<BGsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class BGsModel {
    int id;
    String path;
    String name;

    BGsModel({
        this.id,
        this.path,
        this.name,
    });

    factory BGsModel.fromMap(Map<String, dynamic> json) => BGsModel(
        id: json["id"] == null ? null : json["id"],
        path: json["path"] == null ? null : json["path"],
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "path": path == null ? null : path,
        "name": name == null ? null : name,
    };
}
