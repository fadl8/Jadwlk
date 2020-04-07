import 'package:flutter/material.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/controls/getShare.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/pages/tableDetails.dart';
import 'package:jedwalak/providers/sugProvider.dart';
import 'package:jedwalak/widgets/dialog.dart';
import 'package:jedwalak/widgets/noInternet.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SugsMng extends StatefulWidget {
  _SugsMngState createState() => _SugsMngState();
}

class _SugsMngState extends State<SugsMng> {
  // List<CategoryModel> modelList;

  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);
  final GlobalKey widgetKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.microtask(() {
      Provider.of<SugProvider>(context, listen: false).getData();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SugProvider>(context);
    var veiwlist = provider.deptList.map((f) {
      return Container(
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
          child: ListTile(
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                alertDialog(context, () {
                  Navigator.pop(context);
                  provider.post(context, f);
                }, title: S.of(context).delete_conf);
              },
            ),
            title: Text(
              "${f.messageText}  ",

            ),
            subtitle: Text("${f.createTime}",style: TextStyle(color: accentColor),),
            leading: CircleAvatar(
              child: Icon(MdiIcons.comment),
            ),
          ));
    }).toList();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xfff0f0f0),
      body: Consumer<SugProvider>(builder: (context, model, child) {
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
    
    );
  }
}
