// ignore_for_file: avoid_print

import 'package:avukapp/manager/navigator_manager.dart';
import 'package:avukapp/model/declare.dart';
import 'package:avukapp/viewmodel/declare_view_model.dart';
import 'package:avukapp/viewmodel/lawyer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constant/constant.dart';
import '../../constant/hukuk_category.dart';
import '../../model/lawyer.dart';
import '../appointment/page/appointment_page.dart';
import '../../widgets/custom_card_widget.dart';
import '../../widgets/custom_card_widget_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double removeHeight = 240;
  String? selectedCategory;
  bool loading = false;
  late List<LawyerModel> allLawyer = [];
  late List<DeclareModel> allDeclare = [];
  late List<DeclareModel> selectedDeclare = [];

  late List<String> butunHukukKategorileri;
  Future<void> change() async {
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loading = !loading;
      });
    });
  }

  Future<void> kotegoriyeGoreIlanListele(String kategori) async {
    if (allDeclare.isNotEmpty) {
      selectedDeclare.clear();
      print(selectedDeclare.length);
      for (int i = 0; i < allDeclare.length; i++) {
        print(selectedDeclare.length);
        if (allDeclare[i].declareCategory!.contains("Ceza Hukuku")) {
          selectedDeclare.add(allDeclare[i]);
          print(selectedDeclare.length);
        }
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    change();
    butunHukukKategorileri = hukukAlanlari;
    getAllLawyer();
    getAllDeclare();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kNavyBlueColor,
        onPressed: () {},
        child: const Icon(
          Icons.add,
        ),
      ),
      body: Padding(
        padding: const PagePadding.symtcHrztNormal(),
        child: SingleChildScrollView(
          // physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kNavyBlueColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            selectedCategory =
                                await _openSelectCategory(context);
                            loading = false;
                            setState(() {});

                            if (selectedCategory != null) {
                              await Future.delayed(Duration(seconds: 2));
                            }

                            loading = true;
                            setState(() {});

                            // if (selectedCategory != null) {
                            //   await kotegoriyeGoreIlanListele(
                            //     selectedCategory!,
                            //   );
                            //   setState(() {
                            //     loading = true;
                            //   });
                            // }
                          },
                          child: const Text(
                            "Kategori Seçin",
                            style: TextStyle(
                              color: kCreamColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: height - removeHeight,
                child: loading == true
                    ? ListView.builder(
                        itemCount: selectedDeclare.length,
                        itemBuilder: (context, index) {
                          DeclareModel declareModel = allDeclare[index];
                          return GestureDetector(
                              onTap: () async {
                                print("$index no lu avukata tıklandı");
                              },
                              child: CustomCardWidget(
                                moodel: declareModel,
                                url: imgUrl(index),
                                sagButton: GestureDetector(
                                  onTap: () {},
                                  child: const CustomCardWidgetButton(
                                    buttonTitle: "Soru Sor",
                                  ),
                                ),
                                solButton: GestureDetector(
                                  onTap: () {
                                    NavigatorManager().navigatToWidget(
                                      context,
                                      const AppointmentPage(),
                                    );
                                  },
                                  child: const CustomCardWidgetButton(
                                    buttonTitle: "Randevu Al",
                                  ),
                                ),
                              ));
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: kNavyBlueColor,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration homeTextFieldDecoration() {
    return InputDecoration(
      hintText: "Aramak istediğiniz kelimeyi yaz...",
      labelText: "Ara",
      prefixIcon: const Padding(
        padding: EdgeInsets.only(left: 12.0, right: 6),
        child: Icon(
          Icons.search,
          color: kNavyBlueColor,
        ),
      ),
      hintStyle: const TextStyle(color: kWineRedColor),
      labelStyle: const TextStyle(color: kWineRedColor),
      // floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(
          color: kWineRedColor,
          width: 1.5,
        ),
        gapPadding: 10,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(
          color: kWineRedColor,
          width: 1.5,
        ),
        gapPadding: 10,
      ),
    );
  }

  Future<void> getAllLawyer() async {
    var lawyer = Provider.of<LawyerViewModel>(context, listen: false);
    var lw = await lawyer.getAllLawyer();
    allLawyer = lw;
    print(lw);
  }

  Future<void> getAllDeclare() async {
    var declare = Provider.of<DeclareViewModel>(context, listen: false);
    var resoult = await declare.getAllDeclare();
    allDeclare = resoult;
    selectedDeclare = resoult;
    setState(() {});
  }

  Future<String?> _openSelectCategory(BuildContext context) async {
    String? selectCategory = await showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedClock = -1;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          icon: Text(
            "Saat Seçiniz",
            style: customTextStyle(textSize: 20),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 400,
                  height: 300,
                  child: ListView.builder(
                    itemCount: butunHukukKategorileri.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedClock = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: kCreamColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: selectedClock == index
                                    ? kWineRedColor
                                    : Colors.grey.shade500,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                butunHukukKategorileri[index],
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          actions: [
            Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        kNavyBlueColor,
                      ),
                    ),
                    child: const Text("Çıkış"),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        kNavyBlueColor,
                      ),
                    ),
                    child: const Text("Onayla"),
                    onPressed: () {
                      if (selectedClock != -1) {
                        Navigator.pop(
                          context,
                          butunHukukKategorileri[selectedClock],
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 20),
              ],
            )
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
    return selectCategory;
  }

  TextStyle customTextStyle({
    required double textSize,
    Color? colorx = kNavyBlueColor,
  }) {
    return TextStyle(
      color: colorx,
      fontSize: textSize,
      fontWeight: FontWeight.w500,
    );
  }

  String? imgUrl(int index) {
    for (var i = 0; i < allLawyer.length; i++) {
      if (allDeclare[index].lawyerId == allLawyer[i].lawyerID) {
        return allLawyer[i].profilImgURL!;
      }
    }
  }


  
}
