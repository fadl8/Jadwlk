// To parse this JSON data, do
//
//     final tableModel = tableModelFromJson(jsonString);

import 'dart:convert';

import 'package:jedwalak/models/PhotoModel.dart';
import 'package:jedwalak/models/columnModel.dart';

List<TableModel> tableModelFromJson( str) => List<TableModel>.from((str).map((x) => TableModel.fromMap(x)));

String tableModelToJson(List<TableModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class TableModel {
    int id;
    String name;
    int rowCount;
    int colCount;
    int backgroundId;
    int cateogryId;
    List<ColumnModel> cols;
    
    BGsModel bg;

    TableModel({
        this.id,
        this.name,
        this.rowCount,
        this.colCount,
        this.backgroundId,
        this.cateogryId,
         this.cols,
          this.bg
       
       

    });

    factory TableModel.fromMap(Map<String, dynamic> json) => TableModel(
        id: json["id"] == null ? null :int.parse( json["id"].toString()),
        name: json["name"] == null ? null : json["name"],
        rowCount: json["rowCount"] == null ? null : int.parse(json["rowCount"].toString()),
        colCount: json["colCount"] == null ? null : int.parse(json["colCount"].toString()),
        backgroundId: json["background_Id"] == null ? null : int.parse(json["background_Id"].toString()),
        cateogryId: json["Cateogry_Id"] == null ? null : int.parse(json["Cateogry_Id"].toString()),
         cols: json["cols"] == null ? null : List<ColumnModel>.from(json["cols"].map((x) => ColumnModel.fromMap(x))),
   bg: json["bg"] == null ? null : BGsModel.fromMap(json["bg"]),
    );

    Map<String, dynamic> toMap() => {
        "id": "$id",
        "name":  "$name",
        "rowCount":  "$rowCount",
        "colCount":  "$colCount",
        "background_Id":  "$backgroundId",
        "Cateogry_Id": "$cateogryId",
        "cols": json.encode(List<dynamic>.from(cols.map((x) => x.toMap()))),
        //  "bg": json.encode( bg.toMap()),
    };
}
