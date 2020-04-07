import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/models/TablesModel.dart';
import 'package:jedwalak/models/columnModel.dart';
import 'package:jedwalak/pages/photoPage.dart';
import 'package:jedwalak/providers/TablesProvider.dart';
import 'package:jedwalak/widgets/dialog.dart';
import 'package:jedwalak/widgets/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class AddTable extends StatefulWidget {
  TableModel model;
  TablesProvider provider;
  AddTable(this.provider, {this.model});
  @override
  _AddTableState createState() => _AddTableState();
}

class _AddTableState extends State<AddTable> {
  final formKey = new GlobalKey<FormState>();
  String name, rows, cols;
  List<String> colValues;
  int count = 0, lastId = 0;
  
  @override
  void initState() {
    lastId = Provider.of<TablesProvider>(context, listen: false).id;
    if (widget.model != null) {
      count = widget.model.colCount;
      colValues = List<String>(count);
      Provider.of<TablesProvider>(context, listen: false).background=widget.model.bg;
      for (int i = 0; i < count; i++) {
        if (widget.model.cols.length > i)
          colValues[i] = widget.model.cols[i] != null
              ? widget.model.cols[i].columnName
              : "";
        else
          colValues[i] = "";
      }
    }
    Future.microtask(() {
      Provider.of<TablesProvider>(context, listen: false).getCat();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TablesProvider>(context);
    if (widget.model != null) {
      if (provider.deptList.length > 0) {
        for (var i in provider.deptList) {
          if (i.id == provider.id) {
            provider.name = i.name;
            break;
          }
        }
      }
    }
    var list = <PopupMenuEntry<int>>[];
    var colmns = List<Widget>();
    // colmns list
    for (int i = 0; i < count; i++) {
      colmns.add(Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (txt) {
              colValues[i] = txt;
            },
            initialValue: colValues[i] == null ? "" : colValues[i],
            validator: (txt) {
              return txt.isEmpty ? S.of(context).cannt_be_null : null;
            },
            decoration: InputDecoration(
                labelText: S.of(context).colmn + " ${i + 1}",
                prefixIcon: Icon(MdiIcons.formatLetterCase),
                contentPadding: EdgeInsets.all(10),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ));
    }

    // dropdown list
    int c = 0;
    for (var i in provider.deptList) {
      list.add(PopupMenuItem(
        child: Text(i.name,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            )),
        value: c,
      ));
      c++;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.model == null
              ? S.of(context).addTab
              : S.of(context).editTab),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8.0),
                      child: Text(S.of(context).choseDept)),
                  Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          FutureBuilder(builder: (
                            context,
                            _,
                          ) {
                            switch (provider.loadMore) {
                              case Status.INIT:
                              case Status.COMPLETED:
                                if (list.length > 0)
                                  return Expanded(
                                    child: PopupMenuButton<int>(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 8),
                                        child: Container(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(provider.name,
                                                  style: TextStyle(
                                                    color: prymaryColor,
                                                  )),
                                              Icon(Icons.arrow_drop_down),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onSelected: (index) {
                                        // print('index= $index    data=${data[index].toMap()}');

                                        provider.name =
                                            (provider.deptList[index].name);
                                        provider.id =
                                            (provider.deptList[index].id);
                                      },
                                      itemBuilder: (context) {
                                        return list;
                                      },
                                    ),
                                  );
                                else
                                  return Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 30.0, left: 30, top: 5),
                                        child: Text(
                                          S.of(context).notyp,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ));

                                break;
                              case Status.ERROR:
                                return Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 30.0, left: 30, top: 5),
                                    child: Text(
                                      S.of(context).no_connect,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                );

                                break;
                              case Status.LOADING:
                                return Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 30.0, left: 30, top: 5),
                                    child: Text(
                                      S.of(context).loading,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                );
                                break;
                            }
                          }),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  // name
                  TextFormField(
                    initialValue: widget.model == null ? "" : widget.model.name,
                    keyboardType: TextInputType.text,
                    onSaved: (txt) {
                      name = txt;
                    },
                    validator: (txt) {
                      return txt.isEmpty ? S.of(context).cannt_be_null : null;
                    },
                    decoration: InputDecoration(
                        labelText: S.of(context).tableName,
                        prefixIcon: Icon(MdiIcons.formatLetterCase),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            provider.background==null?" ":provider.background.path,),
                      ),
                      FlatButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                            create: (context) =>
                                                TablesProvider("url"),
                                            child: PhotoesPage(
                                              provider,
                                            ))));
                          },
                          icon: Icon(Icons.image),
                          label: Text(S.of(context).chngBg)),
                          IconButton(icon: Icon(Icons.delete,color: Colors.red,), onPressed: ()
                          {
                            provider.background=null;
                          })
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        // rows number
                        child: TextFormField(
                          initialValue: widget.model == null
                              ? ""
                              : widget.model.rowCount.toString(),
                          keyboardType: TextInputType.number,
                          onSaved: (txt) {
                            rows = txt;
                          },
                          validator: (txt) {
                            return txt.isEmpty
                                ? S.of(context).cannt_be_null
                                : null;
                          },
                          maxLength: 2,
                          decoration: InputDecoration(
                              labelText: S.of(context).rowCount,
                              prefixIcon: Icon(MdiIcons.numeric),
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        // cols number
                        child: TextFormField(
                          // controller: nc,
                          initialValue: widget.model == null
                              ? ""
                              : widget.model.colCount.toString(),
                          keyboardType: TextInputType.number,
                          onSaved: (txt) {
                            cols = txt;
                          },
                          validator: (txt) {
                            return txt.isEmpty
                                ? S.of(context).cannt_be_null
                                : null;
                          },
                          maxLength: 2,
                          onChanged: (txt) {
                            setState(() {
                              count = int.parse(txt.isEmpty ? "0" : txt);
                              colValues = List<String>(count);
                            });
                          },
                          decoration: InputDecoration(
                              labelText: S.of(context).colCount,
                              prefixIcon: Icon(MdiIcons.numeric),
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // cols List,
                  Column(
                    children: colmns,
                  ),
                  // buttons
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // save button
                        FlatButton(
                          color: accentColor,
                          child: Text(
                            S.of(context).save,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          onPressed: () async {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();

                              if (provider.id == 0) {
                                toast(context,
                                    txt: S.of(context).must_chose_dept);
                              } else {
                                var colList = List<ColumnModel>();
                                colValues.forEach((f) {
                                  colList.add(ColumnModel(
                                      id: 0, columnName: f, tableId: 0));
                                });
                                var model = TableModel(
                                    id: widget.model == null
                                        ? null
                                        : widget.model.id,
                                    name: name,
                                    cateogryId: provider.id,
                                    colCount: int.parse(cols),
                                    rowCount: int.parse(rows),
                                    cols: colList,
                                    backgroundId: provider.background==null?0:provider.background.id,
                                    bg: provider.background);
                                // toast(context, txt: columnModelToJson(colList));
                                if (widget.model == null) {
                                  await provider
                                      .post(context, 1, model)
                                      .then((onValue) {
                                    if (provider.id == lastId||lastId==0) {
                                      if (provider.tableList.length > 0)
                                        widget.provider.tableList
                                            .insert(0,provider.tableList.last);
                                    }
                                  });
                                } else {
                                  await provider
                                      .post(context, 2, model)
                                      .then((onValue) {
                                    if (provider.tableList.length > 0) {
                                      var i = widget.provider.tableList
                                          .indexOf(widget.model);
                                      widget.provider.tableList[i] =
                                          provider.tableList.last;
                                    }
                                  });
                                }
                              }
                            }
                          },
                        ),
                        //  cancel button
                        FlatButton(
                          color: prymaryColor,
                          child: Text(
                            S.of(context).cancel,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
