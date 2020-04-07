import 'package:flutter/material.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/controls/getShare.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/models/userModel.dart';
import 'package:jedwalak/providers/HomeIndex.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final loginKey = new GlobalKey<FormState>();
  String email;
  String password, rPassword;
  bool isPasswordVisible = true;
  bool isrPasswordVisible = true;
  var passC=TextEditingController();
  bool unError = false;
  String username;
  userName() => Card(
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          onSaved: (txt) {
            username = txt;
          },
          validator: (txt) {
            return txt.isEmpty
                ? S.of(context).cannt_be_null
//                 : !EmailValidator.validate(txt, true)
//                     ? "البريد الالكتروني غير صحيح"
                : null;
          },
          style: TextStyle(fontSize: 16, color: prymaryColor),
          decoration: InputDecoration(
            labelText: S.of(context).username,
            prefixIcon: Icon(Icons.person),
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          ),
        ),
      );
  emailField() => Card(
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          onSaved: (txt) {
            email = txt;
          },
          validator: (txt) {
            return txt.isEmpty
                ? S.of(context).cannt_be_null
                // : !EmailValidator.validate(txt, true)
                //     ? "البريد الالكتروني غير صحيح"
                : null;
          },
          style: TextStyle(fontSize: 16, color: prymaryColor),
          decoration: InputDecoration(
            labelText: S.of(context).email,
            prefixIcon: Icon(Icons.person),
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          ),
        ),
      );

  passWord() => Card(
        child: TextFormField(
          controller: passC,
          onSaved: (txt) {
            password = txt;
          },
          validator: (txt) {
            return txt.isEmpty ? S.of(context).cannt_be_null : null;
          },
          keyboardType: TextInputType.text,
          obscureText: isPasswordVisible,
          style: TextStyle(fontSize: 16, color: prymaryColor),
          decoration: InputDecoration(
            labelText: S.of(context).pass,
            suffixIcon: IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            prefixIcon: Icon(Icons.lock),
            contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          ),
        ),
      );
  rpassWord() => Card(
        child: TextFormField(
          onSaved: (txt) {
            rPassword = txt;
          },
          validator: (txt) {
            return txt.isEmpty ? S.of(context).cannt_be_null : passC.text!=txt?S.of(context).passnotmutch:null;
          },
          keyboardType: TextInputType.text,
          obscureText: isPasswordVisible,
          style: TextStyle(fontSize: 16, color: prymaryColor),
          decoration: InputDecoration(
            labelText: S.of(context).confirmPass,
            suffixIcon: IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            prefixIcon: Icon(Icons.lock),
            contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                 color: prymaryColor),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: Image(image: AssetImage(Config.getLang()=="ar"?"images/logow.png":"images/logow2.png")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).new_acount,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      Form(
                        key: loginKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            userName(),
                            SizedBox(
                              height: 8,
                            ),
                            emailField(),
                            SizedBox(
                              height: 8,
                            ),
                            passWord(),
                            SizedBox(
                              height: 10,
                            ),
                            rpassWord(),
                            SizedBox(
                              height: 10,
                            ),
                            provider.status != Status.LOADING
                                ? Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: MaterialButton(
                                        minWidth: double.infinity,
                                        height: 42,
                                        onPressed: () {
                                          var index = Provider.of<HomeProvider>(
                                              context);

                                          if (loginKey.currentState
                                              .validate()) {
                                            loginKey.currentState.save();
                                            var user=UserModel(
                                              id: 0,
                                              name: username,
                                              email: email,
                                              password: password,
                                              type: 1,
                                            );
                                            index.regiser(context,user);
         
                                          }
                                        },
                                        color: accentColor,
                                        child: Text(
                                          S.of(context).register,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(

                                        // backgroundColor: prymaryColor,

                                        )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                onPressed: () => Navigator.pop(context)),
          ))
        ],
      ),
    );
  }
}
