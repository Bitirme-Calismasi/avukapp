import 'package:avukapp/constant/app_bar_widget.dart';
import 'package:avukapp/model/declare.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constant/constant.dart';
import '../../../../constant/hukuk_category.dart';

class IlanDuzenle extends StatefulWidget {
  const IlanDuzenle({
    super.key,
    required this.model,
  });
  final DeclareModel model;
  @override
  State<IlanDuzenle> createState() => _IlanDuzenleState();
}

class _IlanDuzenleState extends State<IlanDuzenle> {
  double textfielArasiBosluk = 20;
  final String _editIcon = "assets/icons/profile_design.svg";
  late TextEditingController ilanBasligiController = TextEditingController();
  late TextEditingController ilanIcerigiController = TextEditingController();
  late TextEditingController ilanKategoriController = TextEditingController();
  late TextEditingController ilanTarihiController = TextEditingController();
  late TextEditingController ilanUcretController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var _model = widget.model;
    ilanBasligiController.text = _model.declareTitle ?? "Hata";
    ilanIcerigiController.text = _model.declareContent ?? "Hata";
    ilanKategoriController.text = _model.declareCategory ?? "Hata";
    ilanUcretController.text = _model.declarePrice ?? "Hata";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appTitle: "İlan Düzenle"),
      body: Padding(
        padding: const PagePadding.allNormal(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: inputDecoration(
                  hintTextS: "ilan başlığı",
                  labelTextS: "başlık",
                ),
                controller: ilanBasligiController,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: textfielArasiBosluk),
              TextFormField(
                decoration: inputDecoration(
                  hintTextS: "ilan içeriği",
                  labelTextS: "İçerik",
                ),
                textInputAction: TextInputAction.next,
                controller: ilanIcerigiController,
              ),
              SizedBox(height: textfielArasiBosluk),
              TextFormField(
                decoration: inputDecoration(
                  hintTextS: "ilan ücreti",
                  labelTextS: "Ücret",
                ),
                keyboardType: TextInputType.number,
                controller: ilanUcretController,
              ),
              SizedBox(height: textfielArasiBosluk),
              SizedBox(height: textfielArasiBosluk),
              Text(
                "Seçili Kategori: ${ilanKategoriController.text}",
                style: customTextStyle(textSize: 16),
              ),
              SizedBox(height: textfielArasiBosluk),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        // kullanıcı kategori seçmezse null döner
                        // onun kontrolü yapıldı.

                        String? ftrKtgori = await _openSelectCategory(context);
                        if (ftrKtgori != null) {
                          ilanKategoriController.text = ftrKtgori;
                          print(ilanKategoriController.text);
                        }
                        setState(() {});
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: kNavyBlueColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Kategori Seçimi Yap",
                            style: customTextStyle(
                              textSize: 16,
                              colorx: kCreamColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: textfielArasiBosluk),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: kNavyBlueColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Vazgeç",
                            style: customTextStyle(
                              textSize: 16,
                              colorx: kCreamColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: kNavyBlueColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Onayla",
                            style: customTextStyle(
                              textSize: 16,
                              colorx: kCreamColor,
                            ),
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
      ),
    );
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
                  height: 200,
                  child: GridView.builder(
                    itemCount: hukukAlanlari.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 6,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedClock = index;
                          });
                        },
                        child: Container(
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
                            hukukAlanlari[index],
                          )),
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
                          hukukAlanlari[selectedClock],
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

  InputDecoration inputDecoration({
    required String hintTextS,
    required String labelTextS,
  }) {
    return InputDecoration(
      hintText: hintTextS,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          _editIcon,
          width: 20,
          height: 20,
        ),
      ),
      labelText: labelTextS,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          width: 2,
          color: kNavyBlueColor,
        ),
        gapPadding: 10,
      ),
      errorStyle: const TextStyle(
        color: Colors.white,
        decoration: TextDecoration.underline,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: kNavyBlueColor,
          width: 1.5,
        ),
        gapPadding: 10,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: kNavyBlueColor,
          width: 1.5,
        ),
        gapPadding: 10,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: kNavyBlueColor,
          width: 1.5,
        ),
        gapPadding: 20,
      ),
    );
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
}
