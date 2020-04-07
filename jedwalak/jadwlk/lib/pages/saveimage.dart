import 'dart:io';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/models/TablesModel.dart';
import 'package:jedwalak/providers/TablesProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

GlobalKey _globalKey = new GlobalKey();

Future<String> capturePng(name) async {
  try {
    print('inside');

    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    // String dir = "storage/emulated/0";
    String dir = (await getExternalStorageDirectory() ).path;
    final buffer = byteData.buffer;
    File(dir + "/$name.png").writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    print('png done');

    return dir + "/$name.png";
  } catch (e) {
    print(e);
    return "no path";
  }
}

imge(TableModel model, BuildContext context) {
  var provider = Provider.of<TablesProvider>(context);
  var cols = model.cols.map((f) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Text(
        "${f.columnName}",
        style: TextStyle(color: Colors.white,fontSize: 10),
        textAlign: TextAlign.center,
      )),
    );
  }).toList();

  List<TableRow> rows = provider.ddd.map((f) {
    var col = f.map((f) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          "$f",style: TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        )),
      );
    }).toList();
    return TableRow(
        decoration: BoxDecoration(
            color: provider.ddd.indexOf(f) % 2 == 0
                ? prymaryColor.withOpacity(.2)
                : null),
        children: col);
  }).toList();

  rows.insert(0,
      TableRow(decoration: BoxDecoration(color: prymaryColor), children: cols));

  return RepaintBoundary(
    key: _globalKey,
    child: Container(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
            image: DecorationImage(
              
                image: AssetImage("images/1.jpg"), fit: BoxFit.fill)),
        child: Table(
          border: TableBorder.all(),
          children: rows,
        ),
        // child: DataTable(
        //     headingRowHeight: 80,
        //     columns: cols,
        //     rows: !editmod ? viewList : inputList),
      ),
    ),
  );
}
