// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromMap(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toMap());

class UserModel {
    int id;
    String name;
    String email;
    String password;
    int type;
    String createDate;

    UserModel({
        this.id,
        this.name,
        this.email,
        this.password,
        this.type,
        this.createDate,
    });

    factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"] == null ? null :int.parse(json["id"].toString()),
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        password: json["password"] == null ? null : json["password"],
        type: json["type"] == null ? null :int.parse( json["type"].toString()),
        createDate: json["createDate"] == null ? null :  json["createDate"],
    );

    Map<String, String> toMap() => {
        "id":  "$id",
        "name":   "$name",
        "email": "$email",
        "password":  "$password",
        "type":   "$type",
        "createDate":  "$createDate" ,
    };
}
