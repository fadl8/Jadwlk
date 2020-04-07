import 'package:flutter/material.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/controls/getShare.dart';
import 'package:jedwalak/generated/i18n.dart'; 
import 'package:jedwalak/providers/AppModel.dart';
import 'package:jedwalak/providers/TablesProvider.dart';
// import 'package:jedwalak/providers/BgsProvider.dart'; 
import 'package:jedwalak/widgets/network_image.dart';
import 'package:jedwalak/widgets/noInternet.dart'; 
import 'package:jedwalak/widgets/showimage.dart';
import 'package:provider/provider.dart';

class PhotoesPage extends StatefulWidget {
   
TablesProvider p;
  PhotoesPage(this.p, {Key key}) : super(key: key);

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
      Provider.of<TablesProvider> (context, listen: false).getImages();
      
    });

    super.initState();
  }
 

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TablesProvider>(context);
    var veiwlist = provider.imgtList.map((f) {
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
           widget.p.background=f;
           Navigator.pop(context);
          },
          child: Hero(
            tag: f.name,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: PNetworkImage(
                f.path,
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
      appBar: AppBar(
        
        title: Text(Config.getType()==1 ?S.of(context).bgMng: S.of(context).bgMng),
        centerTitle: true,
      ),
      body:
       Consumer<TablesProvider>(builder: (context, model, child) {
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
                  provider.getImages();
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
