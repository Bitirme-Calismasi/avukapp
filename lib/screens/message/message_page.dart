import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constant/constant.dart';
import '../../model/fav_declare.dart';
import '../../viewmodel/declare_view_model.dart';
import '../../viewmodel/user_view_model.dart';
import '../../widgets/custom_card_widget_button.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
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
                          color: kNavyBlueColor.withOpacity(0.9),
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
                                                "assets/ana_2.jpeg",
                                          ),
                                        ),
                                      ),
                                    ),

                                    Column(
                                      children: [
                                        Text(
                                          "${moodel.declarePrice} Tl",
                                          style:
                                              newTextStyleMethod(textSize: 16),
                                        ),
                                        const SizedBox(height: 6),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                moodel.declareDate
                                                    .toString()
                                                    .split(' ')[0],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: newTextStyleMethod(
                                                    textSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     for (int i = 0; i < 5; i++)
                                    //       const Icon(
                                    //         Icons.star,
                                    //         size: 19,
                                    //         color: Colors.amber,
                                    //       ),
                                    //   ],
                                    // )
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
                                              style: GoogleFonts.dancingScript(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey.shade400,
                                              ),
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
                                          const SizedBox(height: 8),
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
                                          children: [
                                            const Expanded(
                                              child: CustomCardWidgetButton(
                                                buttonTitle: "Randevu Al",
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () async {
                                                  bool sonuc =
                                                      await deleteFavorite(
                                                    id: moodel.declareId!,
                                                  );
                                                  if (sonuc) {
                                                    print("Silindi");
                                                    setState(() {});
                                                  } else {
                                                    print("hayır");
                                                  }
                                                },
                                                child:
                                                    const CustomCardWidgetButton(
                                                  buttonTitle: "Sil",
                                                ),
                                              ),
                                            )
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

  Future<bool> deleteFavorite({required String id}) async {
    final dec = Provider.of<DeclareViewModel>(context, listen: false);
    bool resoult = await dec.deleteFavDeclare(id);
    print(id);
    print(resoult);
    setState(() {
      // İlanı listeden kaldır
      allDeclare.removeWhere((element) => element.declareId == id);
    });
    return resoult;
  }

  //
  void change() {
    setState(() {
      loading = !loading;
    });
  }
}
/*


 */