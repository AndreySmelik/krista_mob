import 'package:flutter/material.dart';
import 'ServerUrl.dart';
import 'Configuration.dart';
import 'Users.dart';
import 'Password.dart';
import 'MainScreen.dart';
import 'WorkPlace.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';
import 'package:catcher/catcher.dart';

var uuid = new Uuid();

class FirstScreen extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _FirstScreenState createState() {
    return _FirstScreenState();
  }
}
class _FirstScreenState extends State<FirstScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );


  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: Catcher.navigatorKey,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          // const Locale('en', 'US'),
          const Locale('ru'),
        ],
        title: 'НПО Криста',
       // debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(0,134,169,1),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child:Image.asset('assets/images/krista.jpg',
                        height: 150.0 ,
                        width: 150.0 )
                ),
                Container(
                    padding: const EdgeInsets.all(8.0), child: Text( _packageInfo.version ,
                  style: TextStyle(fontSize: 16),))
              ],

            ),
          ),
          body: BodyLayout(),
        ));
  }
}

class BodyLayout extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _BodyLayout createState() {
    return _BodyLayout();
  }
}

class _BodyLayout extends State<BodyLayout> {
  String token=uuid.v4();
  var listSubTitles = ['', '', '', '', '',''];

  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );


  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }


  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    loadData();
  }

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); //load data from local storage
    setState(() {
      for (int i=0;i<6;i++)
        listSubTitles[i] = (prefs.getString(i.toString()) ?? '');
      print(listSubTitles[2]);
    });
  }

  refreshToken(){
    token=uuid.v4();
  }

  saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i=0;i<6;i++)
        prefs.setString(i.toString(),listSubTitles[i] );
      print(listSubTitles[3]);
      listSubTitles[5]=_packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(
            'Сервер',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text(listSubTitles[0]),
          onTap: () {
            awaitReturnValueFromNextScreen(context, ServerUrl(), 0);
          },
        ),
        ListTile(
          title: Text('Конфигурация'),
          subtitle: Text(listSubTitles[1]),
          onTap: () {
            awaitReturnValueFromNextScreen(context, Configuration(token: token, url: listSubTitles[0],config:listSubTitles[1]), 1);
          },
        ),
        ListTile(
          title: Text('Пользователь'),
          subtitle: Text(listSubTitles[2]),
          onTap: () {
            awaitReturnValueFromNextScreen(context, Users(token: token, url: listSubTitles[0], config:listSubTitles[1],user:listSubTitles[2] ), 2);
          },
        ),
        ListTile(
          title: Text('Пароль'),
          subtitle: Text(textToStars(listSubTitles[3].length)),
          onTap: () {
            awaitReturnValueFromNextScreen(context, Password(pssw:listSubTitles[3]), 3);
          },
        ),
        ListTile(
          title: Text('Рабочее место'),
          subtitle: Text(listSubTitles[4]),
          onTap: () {
            awaitReturnValueFromNextScreen(context, WorkPlace(token: token, url: listSubTitles[0],config:listSubTitles[1],user:listSubTitles[2] ),4);
          },
        ),
        Container(
            child: Align(
              child: RaisedButton(
                child: Text('Подключение'),
                color: Color.fromRGBO(0,134,169,1),
                textColor: Colors.white,
                onPressed: () {
                  saveData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen(listHeader: listSubTitles, token:token)),
                  ).whenComplete(refreshToken);
                },
              ),
            ))
      ],
    );
  }

  void awaitReturnValueFromNextScreen(
      BuildContext context, Object Screen, number) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Screen,
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      if (result != null) {
        listSubTitles[number] = result;
      }
      // else {        listSubTitles[number] = "";      }
    });
  }
}

String textToStars(int length) {
  String str = '';
  for (int i = 0; i < length; i++) {
    str += '*';
  }
  return str;
}
