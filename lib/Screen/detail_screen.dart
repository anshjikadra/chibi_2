import 'package:chibi_2/ads/ads.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'home_Screen.dart';

bool set = false;

class DetailScreen extends StatefulWidget {
  String? imagedata;
  String? tittle;
  String? cimage;
  int? timage;

  DetailScreen({
    this.imagedata,
    this.tittle,
    this.cimage,
    this.timage,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isload = false;
  bool isloadmore = false;

  int steps = 1;

  List<NetworkImage> imgList = [];

  // DetailScreenData() async {
  //   final http.Response response = await http.get(
  //     Uri.parse(
  //         "$BASE_URL/webservice/get_step.php?code=en&tattoo_id=${widget.id}"),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       isloadmore = false;
  //       isload = true;
  //       step = StepData.fromJson(jsonDecode(response.body));
  //       stepdata = step!.data!;
  //       print(
  //           "--------- Catagory : ${step!.toJson().toString()}   ------------");
  //       print(
  //           "--------- url : ${"$BASE_URL/webservice/get_step.php?code=en&tattoo_id=${widget.id}"} -------------");
  //       print("--------- data : ${stepdata.length} -------------");
  //     });
  //   } else {
  //     throw Exception('Failed to update data.');
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff8376D0),
        title: Text(
          "${widget.tittle}",
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 21, fontFamily: "ReBold"),
        ),
        leadingWidth: 35,
        leading: IconButton(
            onPressed: () {
              Ads.showInterstititalAd(context);
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: false,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () async {
              setState(() {
                if (like.contains(widget.tittle)) {
                  like.remove("${widget.tittle}");
                } else {
                  like.add("${widget.tittle}");
                }
                Pref.set();
                streamGet.add = like;
              });
            },
            child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                width: 36,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: Center(
                    child: Icon(
                  like.contains(widget.tittle)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: const Color(0xffFF2D54),
                  size: 26,
                ))),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            const BannerAdWidget(),
            const Spacer(),
            Expanded(
              flex: 5,
              child: Image.asset(
                steps == 10
                    ? "assets/images/Steps/${widget.cimage}"
                    : "assets/images/Steps/${widget.imagedata}${steps}.png",
                fit: BoxFit.cover,
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(left: 40, right: 40, bottom: 35),
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xffECECEC)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        steps = 1 < steps ? steps - 1 : steps;
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 80,
                      decoration: BoxDecoration(
                          color: const Color(0xff25223E),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 80,
                    decoration: BoxDecoration(
                        color: const Color(0xff25223E),
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                        child: Text(
                      "Steps\n${steps}/${widget.timage}",
                      // "Steps\n${steps + 1}/${stepdata.length}",
                      style: const TextStyle(
                          color: Colors.white, fontFamily: "Regular"),
                      textAlign: TextAlign.center,
                    )),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (steps < 10) {
                          steps = widget.imagedata!.length - 1 > steps
                              ? steps + 1
                              : steps;
                          print(steps);
                        }
                      });

                      // print("assets/images/Steps/${widget.imagedata}${steps}.png");
                      // if(steps==10)
                      //   {
                      //     print("assets/images/Steps/${widget.cimage}.png");
                      //   }
                    },
                    child: Container(
                      height: 45,
                      width: 80,
                      decoration: BoxDecoration(
                          color: const Color(0xff25223E),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
