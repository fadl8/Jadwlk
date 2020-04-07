import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/controls/getShare.dart';
import 'package:jedwalak/controls/urls.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/pages/DeptsPage.dart';
import 'package:jedwalak/pages/TablesPage.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pdf;
// import 'package:printing/printing.dart';
import 'package:jedwalak/pages/myDrawer.dart';
import 'package:jedwalak/pages/photoPage.dart';
import 'package:jedwalak/pages/sugPage.dart';
import 'package:jedwalak/pages/sugmng.dart';
import 'package:jedwalak/providers/AppModel.dart';
import 'package:jedwalak/providers/BgsProvider.dart';
import 'package:jedwalak/providers/TablesProvider.dart';
import 'package:jedwalak/providers/sugProvider.dart';
import 'package:jedwalak/services/restclient.dart';
import 'package:jedwalak/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:jedwalak/providers/DeptsProvider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamController<int> indexcontroller = StreamController<int>.broadcast();
  @override
  void dispose() {
    indexcontroller.close();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showGeneralDialog(
            context: context,
            pageBuilder: (context, anim1, anim2) {},
            barrierDismissible: false,
            barrierColor: Colors.black.withOpacity(0.4),
            barrierLabel: '',
            transitionBuilder: (context, anim1, anim2, child) {
              return Transform.translate(
                child: AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  titlePadding: EdgeInsets.all(0),
                  title: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Icon(
                          Icons.warning,
                          size: 40,
                          color: Colors.orange,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            S.of(context).exit_confirm,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Text(
                                S.of(context).yes,
                                style: TextStyle(
                                    fontSize: 16, color: prymaryColor),
                              ),
                              onPressed: () {
                                if (Provider.of<AppModel>(context)
                                    .scaffoldKey
                                    .currentState
                                    .isDrawerOpen) {
                                  Navigator.of(context).pop(true); 
                                  Navigator.of(context).pop(true);
                                } else
                                  Navigator.of(context).pop(true);
                              },
                            ),
                            IconButton(
                              icon: Text(
                                S.of(context).no,
                                style: TextStyle(
                                    fontSize: 16, color: prymaryColor),
                              ),
                              onPressed: () => Navigator.of(context).pop(false),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                offset: Offset(0, 0),
              );
            },
            transitionDuration: Duration(milliseconds: 200))) ??
        false;


  }

  List<Widget> bodies = [];
  List<String> titles = [];
  @override
  void initState() {
   
    bodies = [
      HomePage(),
      ChangeNotifierProvider(
          create: (context) => DeptsProvider(),
          child: DeptsPage(
            appbar: false,
          )),
      ChangeNotifierProvider(
          create: (context) => TablesProvider(
                Urls.fulltables + "/${Config.getuserid()}",
              ),
          child: TablesPage(
            appbar: false,
            owner: true,
            
          )),
      ChangeNotifierProvider(
          create: (context) => DeptsProvider(),
          child: DeptsPage(
            appbar: false,
          )),
      ChangeNotifierProvider(
          create: (context) => TablesProvider(Urls.tables),
          child: TablesPage(
            appbar: false,
          )),
      ChangeNotifierProvider(
          create: (context) => BGsProvider(Urls.imgs),
          child: PhotoesPage(
            appbar: false,
          )),
      ChangeNotifierProvider(
          create: (context) => SugProvider(Urls.tables), child: SugsMng()),
    ];

    super.initState();
  }

  var index = 0;

  @override
  Widget build(BuildContext context) {
     titles = [
      S.of(context).name,
      S.of(context).depts,
      S.of(context).fullTable,
      S.of(context).deptMng,
      S.of(context).tableMng,
      S.of(context).bgMng,
      S.of(context).sug,
    ];
    var provider = Provider.of<AppModel>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: provider.scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          title: Text(titles[provider.index]),
          centerTitle: true,
        ),
        body: bodies[provider.index],
        drawer: MyDrawer(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
      body: Container(
        color: prymaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: Image.asset(Config.getLang()=="ar"?"images/logow.png":"images/logow2.png"),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(S.of(context).hometitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }


}
