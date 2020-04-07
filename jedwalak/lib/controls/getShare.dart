import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> getshare() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    return user;
  }

class Config{
  static SharedPreferences sh ;
  static Future init() async
  {
    await SharedPreferences.getInstance().then((onValue)
    {
      if (onValue.getString("lang")==null)
        onValue.setString("lang", "ar");
 
      if (onValue.getInt("id")==null)
        onValue.setInt("id", 0);
 
      if (onValue.getString("f_name")==null)
        onValue.setString("f_name", "جدولك");
       if (onValue.getString("pass")==null)
        onValue.setString("pass", "pass");
      if (onValue.getString("phone")==null)
        onValue.setString("phone", "phone");

      if (onValue.getString("email")==null)
        onValue.setString("email", " ");

      if (onValue.getBool("login")==null)
        onValue.setBool("login", false);

      if (onValue.getInt("type")==null)
        onValue.setInt("type", 2);

       
      
      sh=onValue;

    });
  }


static void setLang(String lang)
{
  sh.setString("lang", lang);
}
static void setCharge(double c)
{
  sh.setDouble("charge", c);
}


static void setphone(String phone)
{
  sh.setString("phone", phone);
}
static void setuserid(int id)
{
  sh.setInt("id", id);
}
static void settype(int id)
{
  sh.setInt("type", id);
}
static void setlname(String lname)
{
  sh.setString("l_name", lname);
}
static void setfname(String fname)
{
  sh.setString("f_name", fname);
}
static void settoken(String t)
{
  sh.setString("token", t);
}
static void setEmail(String e)
{
  sh.setString("email", e);
}
static void setpass(String name)
{
  sh.setString("pass", name);
}
static void setlogin(bool login)
{
  sh.setBool("login", login);
}
static void setfcm(String fcm)
{
  sh.setString("fcm", fcm);
}

static Map<String,String> headers()
{
  return {
        "Authorization": "Bearer ${Config.gettoken()}"
      };
}
static String getLang()=>sh.getString("lang");
static String getEmail()=>sh.getString("email");
static String getfname()=>sh.getString("f_name");
static int getuserid()=>sh.getInt("id");
static int getType()=>sh.getInt("type");
static bool getlogin()=>sh.getBool("login");
static String gettoken()=>sh.getString("token");
static String getfcm()=>sh.getString("fcm");
static String getlname()=>sh.getString("l_name");
static String getpass()=>sh.getString("pass");
static String getphone()=>sh.getString("phone");
static double getCharge()=>sh.getDouble("charge");

}

