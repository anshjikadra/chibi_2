import 'package:chibi_2/Screen/home_Screen.dart';
import 'package:chibi_2/ads/ads.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

String APPNAME = "How to Draw People";
String SHARE_APP = "https://apps.apple.com/us/app/how-to-knot/id1668963590";
String MORE_APP =
    "itms-apps://apps.apple.com/us/developer/jasmatbhai-satashiya/id1656353988";

bool ipad = false;

// DBHelperPhoto? DB;
// List<Photo> fav__list = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Pref.initPref;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // const MyApp({super.key});

  @override
  void initState() {
    super.initState();
    loadAd();
    // like=pref.getStringList('like')??[];
  }

  loadAd() async {
    await Ads.loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SafeArea(
        top: false,
        child: HomeScreen(),
      ),
    );
  }
}

class Pref {
  static SharedPreferences? pref;
  static get initPref async {
    pref = await SharedPreferences.getInstance();
    like = get() ?? [];
  }

  static set() => pref!.setStringList("like", like);
  static List<String>? get() => pref!.getStringList('like');
}
