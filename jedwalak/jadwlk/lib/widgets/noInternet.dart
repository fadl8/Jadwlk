
import 'package:flutter/material.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

noInternet(void Function() onPressed) {
  return
   Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.signal_wifi_off,
          color: prymaryColor,
          size: 50,
        ),
        SizedBox(height: 20,),
        Text(
          "لايوجد اتصال بالانترنت",
          style: TextStyle(color: prymaryColor, fontSize: 18),
        ),
        SizedBox(height: 20,),
        FlatButton.icon(
          icon: Icon(
            Icons.sync,
            color: prymaryColor,
            size: 20,
          ),
          onPressed: onPressed,
          label: Text("اعادة المحاولة"),
        )
      ],
    ),
  );
}

noData(title) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          MdiIcons.flaskEmpty,
          color: prymaryColor,
          size: 50,
        ),
        SizedBox(height: 20,),
        Text(
          "$title ",
          style: TextStyle(color: prymaryColor, fontSize: 18),
        ),
      ],
    ),
  );
}

loading(context) {
  return
   Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
       CircularProgressIndicator(),
        SizedBox(height: 20,),
        Text(
         S.of(context).loading,
          style: TextStyle(color: prymaryColor, fontSize: 18),
        ),
        SizedBox(height: 20,),
        ],
    ),
  );
}
notLogin(context)
{
  return  Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.face,
          color: prymaryColor,
          size: 50,
        ),
        SizedBox(height: 20,),
        Text(
          "لم يتم تسجيل الدخول بعد!",
          style: TextStyle(color: prymaryColor, fontSize: 18),
        ),
        SizedBox(height: 20,),
        FlatButton.icon(
          color: prymaryColor,
          icon: Icon(
            Icons.input,
            color: Colors.white,
            size: 20,
          ),
          onPressed:(){
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthPage()));
          },
          label: Text(" تسجيل الدخول الان",style: TextStyle(color: Colors.white),),
        )
      ],
    ),
  );

}
