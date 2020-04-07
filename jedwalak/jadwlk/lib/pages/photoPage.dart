import 'package:flutter/material.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/controls/getShare.dart';
import 'package:jedwalak/generated/i18n.dart'; 
import 'package:jedwalak/providers/AppModel.dart';
import 'package:jedwalak/providers/BgsProvider.dart'; 
import 'package:jedwalak/widgets/network_image.dart';
import 'package:jedwalak/widgets/noInternet.dart'; 
import 'package:jedwalak/widgets/showimage.dart';
import 'package:provider/provider.dart';

class PhotoesPage extends StatefulWidget {
   
bool appbar;
  PhotoesPage({this.appbar = true, Key key}) : super(key: key);

  _PhotoesPageState createState() => _PhotoesPageState();
}

class _PhotoesPageState extends State<PhotoesPage> {
  // List<CategoryModel> modelList;

  ScrollController _scrollController = new ScrollController();

  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);
  final GlobalKey widgetKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.microtask(() {
      Provider.of<BGsProvider>(context, listen: false).getData();
      
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
    var provider = Provider.of<BGsProvider>(context);
    var veiwlist = provider.deptList.map((f) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ShowImage(f.name)));
          },
          child: Hero(
            tag: f.name,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: PNetworkImage(
                f.name,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }).toList();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xfff0f0f0),
      appBar:widget.appbar? AppBar(
        
        title: Text(Config.getType()==1 ?S.of(context).bgMng: S.of(context).bgMng),
        centerTitle: true,
      ):null,
      body:
       Consumer<BGsProvider>(builder: (context, model, child) {
        switch (model.status) {
          case Status.INIT:
          case Status.COMPLETED:
            if (veiwlist.length > 0)
              return GridView.count(
                children: veiwlist,
                crossAxisCount: 2,
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
