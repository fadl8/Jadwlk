import 'package:flutter/material.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/controls/getShare.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/pages/addTable.dart';
import 'package:jedwalak/pages/tableDetails.dart';
import 'package:jedwalak/providers/AppModel.dart';
import 'package:jedwalak/providers/TablesProvider.dart';
import 'package:jedwalak/widgets/dialog.dart';
import 'package:jedwalak/widgets/noInternet.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class TablesPage extends StatefulWidget {
  bool appbar, owner;
  int id;

  TablesPage({this.owner = false, this.id = 0, this.appbar = true, Key key})
      : super(key: key);

  _TablesPageState createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  // List<CategoryModel> modelList;

  ScrollController _scrollController = new ScrollController();

  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);
  final GlobalKey widgetKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.microtask(() {
      Provider.of<TablesProvider>(context, listen: false).getData(widget.id);
      Provider.of<TablesProvider>(context, listen: false).getCat();
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var d = List.generate(5, (_) => List(4));

    var provider = Provider.of<TablesProvider>(context);
    print(provider.nextUrl);
    var veiwlist = provider.tableList.map((f) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                        create: (context) =>
                            TablesProvider("", i: f.rowCount, j: f.colCount),
                        child: TableDetails(f,fill: widget.owner,),
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
                      child: Icon(MdiIcons.table),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          child: Icon(MdiIcons.table),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            "${f.name} ",
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                          create: (context) => TablesProvider(
                                              "url",
                                              n: f.name,
                                              d: f.cateogryId),
                                          child: AddTable(
                                            provider,
                                            model: f,
                                          ),
                                        )));
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
                              provider.post(context, 3, f, f: f);
                            }, title: S.of(context).delete_conf);
                          },
                        )
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
              title: Text(Config.getType() == 1 ? S.of(context).tableMng: S.of(context).tables),
              centerTitle: true,
            )
          : null,
      body: Consumer<TablesProvider>(builder: (context, model, child) {
        switch (model.status) {
          case Status.INIT:
          case Status.COMPLETED:
            if (veiwlist.length > 0)
              return Container(
                  child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(children: veiwlist)));
            else
              return Container(
                  height: double.infinity,
                  child: noData(S.of(context).nodata));
            break;
          case Status.ERROR:
            return Container(
                height: double.infinity,
                child: noInternet(() {
                  provider.getData(widget.id);
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
                // tapSheet(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                              create: (context) =>
                                  TablesProvider("url", n: " "),
                              child: AddTable(provider),
                            )));
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
