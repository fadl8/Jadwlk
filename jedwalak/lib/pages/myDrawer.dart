import 'package:flutter/material.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/controls/getShare.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/pages/about.dart';
import 'package:jedwalak/pages/loginPage.dart';
import 'package:jedwalak/pages/sugPage.dart';
import 'package:jedwalak/providers/AppModel.dart';
import 'package:jedwalak/providers/HomeIndex.dart';
import 'package:jedwalak/widgets/dialog.dart';
import 'package:jedwalak/widgets/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    var list=[S.of(context).user,S.of(context).admin,S.of(context).vistor];
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
            
               Container(
                 height: 200,
                   color:prymaryColor, child: Image.asset(Config.getLang()=="ar"?"images/logow.png":"images/logow2.png")),
                   SizedBox(height: 20,),
              Text("${Config.getfname()} ",style: TextStyle(
                color: Colors.white,fontSize: 20
              ),),
               Text(
                " ${list[Config.getType()]} ",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
                  
              ],
            ),
              decoration: BoxDecoration(
                color: prymaryColor,
                   
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
                // depts
                Config.getType()!=1? ListTile(
                  trailing: Icon(
                    Icons.table_chart,
                    color: Colors.redAccent,
                  ),
                  leading: Text(S.of(context).depts,
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                  onTap: () async {
                    Navigator.of(context).pop();
                  Provider.of<AppModel>(context).index=1;
                  },
                ):Container(),
                // tables
               
               // ful tables
               Config.getType()==0? ListTile(
                  trailing: Icon(
                    MdiIcons.table,
                    color: prymaryColor,
                  ),
                  leading: Text(S.of(context).fullTable,
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.of(context).pop();
                   Provider.of<AppModel>(context).index=2;
                  },
                ):Container(),

                // admin menue
                Config.getType()==1&&Config.getlogin()

                    ? Column(
                        children: <Widget>[
                          // deots management
                          ListTile(
                            trailing: Icon(
                              Icons.table_chart,
                              color: prymaryColor,
                            ),
                            leading: Text(S.of(context).deptMng,
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.of(context).pop();
                               Provider.of<AppModel>(context).index=3;
                            },
                          ),
                          // tables management
                          ListTile(
                            trailing: Icon(
                              MdiIcons.table,
                              color: prymaryColor,
                            ),
                            leading: Text(S.of(context).tableMng,
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.of(context).pop();
                              Provider.of<AppModel>(context).index=4;
                            },
                          ),
                          // backgrounds management
                          // ListTile(
                          //   trailing: Icon(
                          //     Icons.image,
                          //     color: prymaryColor,
                          //   ),
                          //   leading: Text(S.of(context).bgMng,
                          //       style: TextStyle(
                          //           color: Colors.blueGrey,
                          //           fontWeight: FontWeight.bold)),
                          //   onTap: () {
                          //     Navigator.of(context).pop();
                          //    Provider.of<AppModel>(context).index=5;
                          //   },
                          // ),
                          ListTile(
                            trailing: Icon(
                              Icons.comment,
                              color: prymaryColor,
                            ),
                            leading: Text(S.of(context).sug,
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.of(context).pop();
                             Provider.of<AppModel>(context).index=6;
                            },
                          ),
                        ],
                      )
                    : Container(),
                // suggestions
               Config.getType()!=1? ListTile(
                  trailing: Icon(
                    Icons.comment,
                    color: prymaryColor,
                  ),
                  leading: Text(S.of(context).sug,
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChangeNotifierProvider<
                                        HomeProvider>(
                                    create: (_) => HomeProvider(0),
                                    child: SugPage())));
                  },
                ):Container(),
                // about us
                ListTile(
                  trailing: Icon(
                    Icons.info,
                    color: prymaryColor,
                  ),
                  leading: Text(S.of(context).aboutUs,
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AboutUsPage()));
                  },
                ),
                // login
               Config.getlogin() ? ListTile(
                  trailing: Icon(
                    MdiIcons.logout,
                    color: prymaryColor,
                  ),
                  leading: Text(S.of(context).logout,
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                  onTap: () {
                   
                    alertDialog(context, ()
                    { 
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                       Provider.of<AppModel>(context).index=0;
                   Config.setlogin(false);
                   Config.setfname(S.of(context).name);
                   Config.setuserid(0);
                   Config.settype(2);
                   toast(context,txt:S.of(context).successlogout);

                    },title: S.of(context).exit_confirm);
                    
                  },
                ):ListTile(
                  trailing: Icon(
                    MdiIcons.login,
                    color: prymaryColor,
                  ),
                  leading: Text(S.of(context).login,
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChangeNotifierProvider<
                                        HomeProvider>(
                                    create: (_) => HomeProvider(0),
                                    child: LoginPage())));
                  },
                ),
                // language
                ListTile(
                  trailing: Icon(
                    Icons.language,
                    color: prymaryColor,
                  ),
                  leading: Text(S.of(context).lang,
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Config.getLang() == "ar"
                                          ? Provider.of<AppModel>(context)
                                              .setLang('en')
                                          : Provider.of<AppModel>(context)
                                              .setLang('ar');
                  },
                ),
                Row(
                  children: <Widget>[

                  ],
                ),
                Divider(),

             
              ],
            ),
          )
        ],
      ),
    );
  }
}
