import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant/constant.dart';
import '../../model/fav_declare.dart';
import '../../viewmodel/declare_view_model.dart';
import '../../viewmodel/user_view_model.dart';
import '../../widgets/custom_card_widget_button.dart';

class MyMessagePage extends StatefulWidget {
  const MyMessagePage({super.key});

  @override
  State<MyMessagePage> createState() => _MyMessagePageState();
}

class _MyMessagePageState extends State<MyMessagePage> {
  double removeHeight = 200;
  late List<FavDeclareModel> allDeclare = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getAllFavorite();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: height - removeHeight,
          child: loading == true
              ? ListView.builder(
                  itemCount: allDeclare.length,
                  itemBuilder: (context, index) {
                    FavDeclareModel moodel = allDeclare[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: width * 0.9,
                        height: height * 0.3,
                        decoration: BoxDecoration(
                          color: kNavyBlueColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(24)),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            moodel.lawyerProfilUrl ??
                                                "https://imgs.search.brave.com/RU0yRHJk_pU92g_cE88XYWs-HrLaxwScJqMBD1t_Sz8/rs:fit:844:225:1/g:ce/aHR0cHM6Ly90c2Uy/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC55/b0haN09DTWZyWkc5/WGVWak42Q1dRSGFF/SyZwaWQ9QXBp",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              moodel.declareTitle ?? "Hata",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: newTextStyleMethod(
                                                  textSize: 20),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              moodel.declareCategory ??
                                                  "Hata !!",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: newTextStyleMethod(
                                                  textSize: 16),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  moodel.declareDate
                                                      .toString()
                                                      .split(' ')[0],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: newTextStyleMethod(
                                                      textSize: 16),
                                                ),
                                                Text(
                                                  "${moodel.declarePrice} Tl",
                                                  style: newTextStyleMethod(
                                                      textSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              moodel.declareContent ?? "Hata",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: newTextStyleMethod(
                                                  textSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        child: Row(
                                          children: const [
                                            Expanded(
                                              child: CustomCardWidgetButton(
                                                buttonTitle: "Randevu Al",
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: CustomCardWidgetButton(
                                                  buttonTitle: "Sil"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: kNavyBlueColor,
                  ),
                ),
        ),
      ),
    );
  }

  TextStyle newTextStyleMethod({required double textSize}) {
    return TextStyle(
      fontSize: textSize,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  //
  Future<void> getAllFavorite() async {
    final user = Provider.of<UserViewModel>(context, listen: false);
    final dec = Provider.of<DeclareViewModel>(context, listen: false);
    List<FavDeclareModel> dec1 =
        await dec.getForFavorieDeclare(user.user!.userID!);
    change();
    for (var element in dec1) {
      debugPrint(element.declareId);
    }
    allDeclare = dec1;
  }

  //
  void change() {
    setState(() {
      loading = !loading;
    });
  }
}
