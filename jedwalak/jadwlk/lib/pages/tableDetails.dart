import 'dart:typed_data';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/controls/getShare.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/models/TablesModel.dart';
import 'package:jedwalak/models/tdataModel.dart';
import 'package:jedwalak/pages/saveimage.dart';
import 'package:jedwalak/providers/TablesProvider.dart';
import 'package:jedwalak/widgets/noInternet.dart';
import 'package:jedwalak/widgets/toast.dart';
import 'package:provider/provider.dart';

class TableDetails extends StatefulWidget {
  TableModel model;
  bool fill;
  TableDetails(this.model, {this.fill = false});
  @override
  _TableDetailsState createState() => _TableDetailsState();
}

class _TableDetailsState extends State<TableDetails> {
  var list = List<DataRow>();
  bool inside = false, editmod = false, fill;
  Uint8List imageInMemory;
  final loginKey = new GlobalKey<FormState>();

  @override
  void initState() {
    fill = widget.fill;
    if(fill)
    {
    Future.microtask(() {
      Provider.of<TablesProvider>(context, listen: false)
          .getTableData(widget.model.id, Config.getuserid());
    });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TablesProvider>(context);

    var cols = widget.model.cols.map((f) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          "${f.columnName}",
          style: TextStyle(color: Colors.white),
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
            "$f",
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

    rows.insert(
        0,
        TableRow(
            decoration: BoxDecoration(color: prymaryColor), children: cols));

    List<TableRow> inputList = [];

    for (int i = 0; i < provider.ddd.length; i++) {
      List<Widget> col = [];
      for (int j = 0; j < provider.ddd[i].length; j++) {
        col.add(TextFormField(
          initialValue:
              provider.ddd[i][j] == null ? "" : "${provider.ddd[i][j]}",
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 5,
          onSaved: (txt) {
            provider.additem(i, j, txt);

            print(
                "ffffffffffffffffffffffffffffffffffffffffffffffffffff [$i][$j] ");
          },
          style: TextStyle(fontSize: 16, color: Colors.black),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        ));
      }

      inputList.add(TableRow(children: col));
    }
    inputList.insert(
        0,
        TableRow(
            decoration: BoxDecoration(color: prymaryColor), children: cols));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${widget.model.name}"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          imge(widget.model, context),
          Container(
            color: Colors.white,
            child: Consumer<TablesProvider>(builder: (context, model, child) {
              switch (model.status) {
                case Status.INIT:

                case Status.COMPLETED:
                  if (rows.length > 0)
                    return SingleChildScrollView(
                      child: Form(
                        key: loginKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage("images/21.jpg"),
                                          fit: BoxFit.fill)),

                                  child: Table(
                                    defaultColumnWidth: FixedColumnWidth(
                                      widget.model.colCount < 5
                                          ? mywidth(context) /
                                              widget.model.colCount
                                          : 100,
                                    ),
                                    border: TableBorder.all(),
                                    children: !editmod ? rows : inputList,
                                  ),

                                  // child: DataTable(

                                  //     headingRowHeight: 80,

                                  //     columns: cols,

                                  //     rows: !editmod ? viewList : inputList),
                                ),
                              ),
                            ),
                            inside
                                ? CircularProgressIndicator()
                                : imageInMemory != null
                                    ? Container(
                                        child: Image.memory(
                                          imageInMemory,
                                          fit: BoxFit.contain,
                                        ),
                                        margin: EdgeInsets.all(10))
                                    : Container(),
                            SizedBox(
                              height: 100,
                            ),
                            Config.getType() == 0
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      fill && !editmod
                                          ? FlatButton.icon(
                                              color: prymaryColor,
                                              onPressed: () {},
                                              icon: Icon(Icons.image,
                                                  color: Colors.white),
                                              label: Text(
                                                S.of(context).chngBg,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))
                                          : Container(),
                                      !fill
                                          ? FlatButton.icon(
                                              color: prymaryColor,
                                              onPressed: () {
                                                setState(() {
                                                  fill = true;
                                                  editmod = true;
                                                });
                                              },
                                              icon: Icon(Icons.edit,
                                                  color: Colors.white),
                                              label: Text(
                                                S.of(context).fillTable,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))
                                          : Container(),
                                      fill && !editmod
                                          ? FlatButton.icon(
                                              color: prymaryColor,
                                              onPressed: () async {
                                                await capturePng(
                                                        widget.model.name)
                                                    .then((onValue) {
                                                  Flushbar<bool>(
                                                    title:
                                                        S.of(context).successSaveImage,
                                                    // showProgressIndicator: true,
                                                    message: " $onValue",
                                                    duration:
                                                        Duration(seconds: 2),
                                                    isDismissible: false,
                                                  )..show(context);
                                                });
                                              },
                                              icon: Icon(Icons.file_download,
                                                  color: Colors.white),
                                              label: Text(
                                                S.of(context).saveAsImage,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))
                                          : Container(),
                                    ],
                                  )
                                : Container(),
                            editmod
                                ? FlatButton.icon(
                                    color: prymaryColor,
                                    onPressed: () {
                                      setState(() {
                                        editmod = false;
                                        fill = widget.fill;
                                      });
                                    },
                                    icon:
                                        Icon(Icons.close, color: Colors.white),
                                    label: Text(
                                      S.of(context).cancel,
                                      style: TextStyle(color: Colors.white),
                                    ))
                                : Container(),
                            SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                    );
                  else
                    return Container(
                        height: double.infinity,
                        child: noData(S.of(context).nodata));

                  break;

                case Status.ERROR:
                  return Container(
                      height: double.infinity,
                      child: noInternet(() {
                        // provider.getTablesData();
                      }));

                  break;

                case Status.LOADING:
                  return Container(height: double.infinity, child: loading(context));

                  break;
              }
            }),
          ),
        ],
      ),
      floatingActionButton: Config.getType() == 0 && fill
          ? FloatingActionButton(
              backgroundColor: prymaryColor,
              child: Icon(editmod ? Icons.save : Icons.edit),
              onPressed: () {
                setState(() {
                  if (editmod) {
                    loginKey.currentState.save();
                    editmod = false;
                    provider.fillList(widget.model.id);
                    if (provider.tableDataList.length > 0) {
                      toast(context,
                          txt: provider.tableDataList.length.toString());
                      provider.addData(context, {
                        "t": "${widget.model.id}",
                        "u": "${Config.getuserid()}",
                        "data": tDataModelToJson(provider.tableDataList)
                      });
                    }
                  } else
                    editmod = true;
                });
              })
          : null,
    );
  }
}
