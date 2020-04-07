import 'package:flutter/material.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/controls/getShare.dart';
import 'package:jedwalak/controls/urls.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/models/categoryModel.dart';
import 'package:jedwalak/pages/TablesPage.dart';
import 'package:jedwalak/providers/DeptsProvider.dart';
import 'package:jedwalak/providers/TablesProvider.dart';
import 'package:jedwalak/widgets/dialog.dart';
import 'package:jedwalak/widgets/noInternet.dart';
import 'package:provider/provider.dart';

class DeptsPage extends StatefulWidget {
  bool appbar;
  DeptsPage({this.appbar = true, Key key}) : super(key: key);
  _DeptsPageState createState() => _DeptsPageState();
}

class _DeptsPageState extends State<DeptsPage> {
  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);
  final GlobalKey widgetKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.microtask(() {
      Provider.of<DeptsProvider>(context, listen: false).getData();
    });
    super.initState();
  }
   

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DeptsProvider>(context);
    var veiwlist = provider.deptList.map((f) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                        create: (context) => TablesProvider(
                          Urls.tables + '/${f.id}',
                        ),
                        child: TablesPage(model: f,),
                      )));
        },
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                    color: prymaryColor, blurRadius: 2, offset: Offset(-1, 2)),
              ],
              color: Colors.white,
            ),
            child: Config.getType() != 1
                ? ListTile(
                    title: Text(
                      "${f.name}",
                    ),
                    leading: CircleAvatar(
                      child: Icon(Icons.table_chart),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              child: Icon(Icons.table_chart),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "${f.name}",
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                deptDialog(context, add: 2, model: f);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                alertDialog(context, () {
                                  Navigator.pop(context);
                                  provider.post(context, 3, f,f:f);
                                }, title: S.of(context).delete_conf);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
      );
    }).toList();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xfff0f0f0),
      appBar: widget.appbar
          ? AppBar(
              title: Text(Config.getType() == 1 ? S.of(context).deptMng : S.of(context).depts),
              centerTitle: true,
            )
          : null,
      body: Consumer<DeptsProvider>(builder: (_, model, child) {
        switch (model.status) {
          case Status.INIT:
          case Status.COMPLETED:
            if (veiwlist.length > 0)
              return Container(
                  child:
                      SingleChildScrollView(child: Column(children: veiwlist)));
            else
              return Container(
                  height: double.infinity,
                  child: noData(S.of(context).nodata));
            break;
          case Status.ERROR:
            return Container(
                height: double.infinity,
                child: noInternet(() {
                  provider.getData();
                }));

            break;
          case Status.LOADING:
            return Container(height: double.infinity, child: loading(context));
            break;
        }
      }),
      floatingActionButton: Config.getType() == 1
          ? FloatingActionButton(
            backgroundColor: prymaryColor,
              onPressed: () {
                deptDialog(context);
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
