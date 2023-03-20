import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chibi_2/Model/jmodel.dart';
import 'package:chibi_2/database/create_model.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tying_knots/Screen/detail_screen.dart';
import 'package:http/http.dart' as http;



import '../main.dart';
import 'detail_screen.dart';

List<String> favlist = [];
List<String> favlist2 = [];
String favourite = "";


List<String> like=[];

bool isLike=false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  int id = 0;
  bool isload = false;
  bool isloadmore = false;
  String selectedid = "0";

  int tabid = 11;

  // bool like = false;

  int selected = 0;


  List colorlist = [
    Color(0xff9E896F),
    Color(0xff5D747B),
    Color(0xff67618E),
    Color(0xff8E618A),
    Color(0xff7D8E61),
  ];

  int isSelectd=0;


  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    // googlePlayIdentifier: 'fr.skyost.example',
    appStoreIdentifier: '1668963590',
  );

  getUserfontsize() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // favlist2 = prefs.getStringList('favid')!;
      favourite = favlist2.join(",");
      print(favlist2);
    });

  }



  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    get_data();
    isIpad();
    getUserfontsize();
    // DB = DBHelperPhoto();
    // get_like();


    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(
          context,
          title: 'Rate this app',
          message: 'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
          rateButton: 'RATE',
          noButton: 'NO THANKS',
          laterButton: 'MAYBE LATER',
          listener: (
              button) {
            switch (button) {
              case RateMyAppDialogButton.rate:
                print('Clicked on "Rate".');
                break;
              case RateMyAppDialogButton.later:
                print('Clicked on "Later".');
                break;
              case RateMyAppDialogButton.no:
                print('Clicked on "No".');
                break;
            }
            return true;
          },
          ignoreNativeDialog: Platform.isAndroid,
          dialogStyle: const DialogStyle(),
          onDismissed: () =>
              rateMyApp.callEvent(RateMyAppEventType
                  .laterButtonPressed),
        );
      }
    }
    );
  }
  
  
   List<Data> titalans=[];
  //
  //
  //
  get_data() async {
    var data=await rootBundle.loadString("assets/myimage.json");
    List list=json.decode(data);
    titalans=list.map((e) => Data.fromJson(e)).toList();
    setState(() {

    });
  }

  // get data()async
  // {
  //  var data=  await  rootBundle.loadString("");
  //  List list=json.decode(data);
  //  titalans=list.map((e) => Data.fromJson(e)).toList();
  // }





  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        endDrawer: Drawer(
          child: Container(
            padding: EdgeInsets.only(left: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15,top: 30),
                  color: Color(0xff8376D0),
                  height: 210,
                  child: Row(
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.asset("assets/1024.png",height: 100,width: 100,)),
                      SizedBox(width: 15,),
                      Text("$APPNAME",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "ReBold"),),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    SizedBox(width: 15,),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 270,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.home,size: 28,color: Colors.grey,),
                            Text("Home",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,fontFamily: "Regular"),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    SizedBox(width: 15,),
                    InkWell(
                      onTap: (){
                        rateMyApp.showStarRateDialog(
                          context,
                          title: 'Rate this app',
                          // The dialog title.
                          message:
                          'You like this app ? Then take a little bit of your time to leave a rating :',
                          actionsBuilder: (context, stars) {

                            return [
                              ElevatedButton(
                                child: Text('OK'),
                                onPressed: () async {
                                  print('Thanks for the ' +
                                      (stars == null ? '0' : stars.round().toString()) +
                                      ' star(s) !');

                                  await rateMyApp
                                      .callEvent(RateMyAppEventType.rateButtonPressed);
                                  Navigator.pop<RateMyAppDialogButton>(
                                      context, RateMyAppDialogButton.rate);
                                },
                              ),
                            ];
                          },
                          ignoreNativeDialog: Platform.isAndroid,
                          // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
                          dialogStyle: const DialogStyle(
                            // Custom dialog styles.
                            titleAlign: TextAlign.center,
                            messageAlign: TextAlign.center,
                            messagePadding: EdgeInsets.only(bottom: 20),
                          ),
                          starRatingOptions: const StarRatingOptions(),
                          // Custom star bar rating options.
                          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
                              .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
                        );
                      },
                      child: Container(
                        width: 270,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.star_rate,size: 28,color: Colors.grey,),
                            Text("Rate Us",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,fontFamily: "Regular"),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    SizedBox(width: 15,),
                    InkWell(
                      onTap: (){
                        Share.share(SHARE_APP);
                      },
                      child: Container(
                        width: 270,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.share,size: 28,color: Colors.grey,),
                            Text("Share App",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,fontFamily: "Regular"),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    SizedBox(width: 15,),
                    InkWell(
                      onTap: (){
                        Share.share(MORE_APP);
                      },
                      child: Container(
                        width: 270,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/app-store.png",height: 28,width: 28,color: Colors.grey,),
                            Text("More App",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,fontFamily: "Regular"),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
              ],
            )
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color(0xff8376D0),
          title: Text(
            "$APPNAME",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21,fontFamily: "ReBold"),
          ),
          centerTitle: false,
          elevation: 0,
          actions: [
            Builder(
              builder: (context) {
                return InkWell(
                  onTap: (){
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: Image.asset(
                    "assets/setting.png",
                    height: 27,
                    width: 27,
                  ),
                );
              }
            ),
            SizedBox(
              width: 15,
            )
          ],
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 18,fontFamily: "Regular",fontWeight: FontWeight.w400),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelPadding: EdgeInsets.symmetric(vertical: 9),
            indicatorColor: Colors.transparent,
            onTap: (int index)async {
              setState(()  {
                id = index;
              });
              final prefs = await SharedPreferences.getInstance();
              favlist = favlist.isEmpty ? ["0"] :prefs.getStringList('favid')!;
              favourite = favlist.join(",");
              // favourite == "" ? null :FavouriteScreenData();
            },
            tabs: [
              Container(
                  margin: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: id == 0 ? Color(0xffFF2D54) : Colors.transparent),
                  height: 38,
                  width: 105,
                  child: Tab(
                    text: "Discover",
                  )),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: id == 1 ? Color(0xffFF2D54) : Colors.transparent),
                  height: 38,
                  width: 105,
                  child: Tab(
                    text: "Favourite",
                  )),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: streamGet.stream,
          builder: (context, snapshot) {
            return TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                //  ---------- Basic -------------
                Container(
                  padding:
                  EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 18),
                  child:


                  GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ipad == true ?2 : 1,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          mainAxisExtent: ipad == true ? 200 : 160
                      ),
                      itemCount: titalans.length,
                      itemBuilder: (context, index) {

                        return InkWell(
                          onTap: () {

                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return DetailScreen(imagedata: titalans[index].prefix,tittle: titalans[index].title,cimage: titalans[index].cover,timage:titalans[index].totalImage,);
                            },));

                            //passing data titalli
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                                color: colorlist[index % colorlist.length],
                                borderRadius: BorderRadius.circular(10)),
                            height: 160,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 200,
                                        child: Text(

                                          "${titalans[index].title}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "ReBold"),
                                        )),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 38,
                                          width: 106,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(50),
                                              color: Color(0xffD9D9D9)),
                                          child: Center(
                                              child: Text(

                                                "${titalans[index].totalImage} steps",
                                                style: TextStyle(
                                                    fontFamily: "Regular",
                                                    color: colorlist[index % colorlist.length],
                                                    fontWeight: FontWeight.w700),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: ()async{
                                            // setState(()  {
                                            //
                                            //   // selected = index;
                                            //   //
                                            //   // selectedid = basicdata[index].tId!;
                                            //   //
                                            //   // basicdata[index].isfav == false ? favlist.add(basicdata[index].tId!) : null;
                                            //   // for (var i = 0; i < favlist.length; i++){
                                            //   //   if(favlist[i] == basicdata[index].tId) {
                                            //   //     int item = i;
                                            //   //     basicdata[index].isfav == true ?favlist.removeAt(item) : null;
                                            //   //   }
                                            //   // }
                                            //   // basicdata[index].isfav = basicdata[index].isfav == false ;
                                            //   // print(favourite);
                                            //   // print("ID:${id}");
                                            //   // print("FAV:${fav}");
                                            //   // print("FAVDATA:${favdata}");
                                            //   // print("FAVOURITES:${favourite}");
                                            //   // print("FAVLIST:${favlist}");
                                            //   // print("FAVLIST2:${favlist2}");
                                            //   // like=true;
                                            //   // print("LIKE:${like}");
                                            //
                                            //
                                            //
                                            //
                                            //   }
                                            //   );
                                            // final prefs = await SharedPreferences.getInstance();
                                            // await prefs.setStringList('favid', favlist);
                                            //
                                            // favlist = prefs.getStringList('favid')!;
                                            // FavouriteScreenData();


                                            setState(() {


                                              // isSelectd=index;
                                              // isLike=!isLike;
                                              //
                                              //  DB = DBHelperPhoto();
                                              //  Photo photo = Photo("${titalans[index].title}","${titalans[index].totalImage}");
                                              //  DB!.save(photo);
                                              //  print(photo.id);

                                              if(like.contains('${titalans[index].title}'))
                                              {
                                                like.remove(titalans[index].title);
                                              }
                                              else
                                              {
                                                like.add(titalans[index].title);
                                              }
                                              Pref.set();
                                              streamGet.add=like;

                                            });

                                          },
                                          child: Container(
                                            height: 38,
                                            width: 38,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                color: Color(0xffFFFFFF)
                                                    .withOpacity(0.44)),
                                            child: Center(
                                              child:Icon(
                                                like.contains(titalans[index].title) ? Icons.favorite :
                                                Icons.favorite_border,
                                                color: Color(0xffFF2D54),
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Image.asset("assets/images/Steps/${titalans[index].cover}",fit: BoxFit.cover,),

                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                //  ---------- Favourite ----------
                Container(
                  padding:
                  EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 18),
                  child:  like == "" ? Center(child: Text("Data not found",style: TextStyle(fontSize: 22),),):
                  GridView.builder(

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ipad == true ?2 : 1,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          mainAxisExtent: ipad == true ? 200 : 160
                      ),
                      itemCount:like.length,
                      itemBuilder: (context, index) {
                        var i = titalans.indexWhere((e) => e.title==like[index]);
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(imagedata: titalans[index].prefix,tittle: titalans[index].title,cimage: titalans[index].cover,timage:titalans[index].totalImage)));
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                                color: colorlist[index % colorlist.length],
                                borderRadius: BorderRadius.circular(10)),
                            height: 160,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 200,
                                        child: Text(
                                          titalans[i].title,
                                          // book_mark[index].save_bookmark,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,fontFamily: "ReBold"),
                                        )),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 38,
                                          width: 106,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(50),
                                              color: Color(0xffD9D9D9)),
                                          child: Center(
                                              child: Text(
                                                "${titalans[i].totalImage} steps",
                                                style: TextStyle(
                                                    fontFamily: "Regular",
                                                    color: colorlist[index % colorlist.length],
                                                    fontWeight: FontWeight.w700),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () async {

                                            like.remove(titalans[i].title);
                                            setState(() {

                                            });
                                          },
                                          child: Container(
                                            height: 38,
                                            width: 38,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                color: Color(0xffFFFFFF)
                                                    .withOpacity(0.44)),
                                            child: Center(
                                              child: Icon(
                                                Icons.favorite,
                                                color: Color(0xffFF2D54),
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  height: 105,
                                  width: 105,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Image.asset("assets/images/Steps/${titalans[i].cover}",fit: BoxFit.cover,),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          }
        ),
      ),
    );
  }


  isIpad() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    if (info.model!.toLowerCase() == "ipad") {
      ipad = true;
    }
  }
}

StreamGet streamGet = StreamGet();

class StreamGet{
  StreamController streamController =StreamController.broadcast();
  Stream get stream=>streamController.stream;
  set add(dynamic event)=>streamController.sink.add(event);
}