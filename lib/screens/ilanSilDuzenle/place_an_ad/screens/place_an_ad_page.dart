import 'package:avukapp/viewmodel/declare_view_model.dart';
import 'package:avukapp/viewmodel/user_view_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../constant/app_bar_widget.dart';
import '../../../../constant/constant.dart';
import '../../../../constant/hukuk_category.dart';
import '../../../../model/declare.dart';

class PlaceAnAdPage extends StatefulWidget {
  const PlaceAnAdPage({super.key});

  @override
  State<PlaceAnAdPage> createState() => _PlaceAnAdPageState();
}

class _PlaceAnAdPageState extends State<PlaceAnAdPage> {
  final String _editIcon = "assets/icons/profile_design.svg";
  TextEditingController ilanBasligiController = TextEditingController();
  TextEditingController ilanIcerigiController = TextEditingController();
  TextEditingController ilanKategoriController = TextEditingController();
  TextEditingController ilanTarihiController = TextEditingController();
  TextEditingController ilanUcretController = TextEditingController();

  String? ilanAdi = "";
  bool confirm = false;
  void changeConfirm() {
    setState(() {
      confirm = !confirm;
    });
  }

  late DeclareModel model;

  @override
  Widget build(BuildContext context) {
    final lawyer = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      appBar: const CustomAppBar(
        appTitle: "İlan Ver",
      ),
      body: Padding(
        padding: const PagePadding.allHigh(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              textCustomTitle(title: "İlan Başlığını Yazın"),
              const SizedBox(height: 10),
              TextFormField(
                decoration: inputDecoration(
                  hintTextS: "İlan başlığı yazınız",
                  labelTextS: "İlan Başlığı",
                ),
                controller: ilanBasligiController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 30),
              textCustomTitle(title: "İlan İçeriğini Yazın"),
              const SizedBox(height: 10),
              TextFormField(
                decoration: inputDecoration(
                  hintTextS: "İlan İçeriğini yazınız",
                  labelTextS: "İlan İçeriği",
                ),
                controller: ilanIcerigiController,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 30),
              textCustomTitle(title: "İlan Kategorisini Seçiniz"),
              const SizedBox(height: 10),
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
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 50),
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
              const SizedBox(height: 30),
              textCustomTitle(title: "Ücreti Belirleyiniz"),
              const SizedBox(height: 10),
              TextFormField(
                decoration: inputDecoration(
                  hintTextS: "İlan ücretini belirleyiniz",
                  labelTextS: "Ücret",
                ),
                keyboardType: TextInputType.number,
                controller: ilanUcretController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 30),
              textCustomTitle(
                title: "İlan Tarihiniz Bugündür.",
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: kNavyBlueColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: confirm == true
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: kCreamColor,
                        ),
                      )
                    : Center(
                        child: GestureDetector(
                          onTap: () {
                            changeConfirm();
                            Future.delayed(const Duration(seconds: 1), () {
                              changeConfirm();
                              _declareSubmit(lawyer.user?.userID, context);
                            });
                          },
                          child: const Text(
                            "Onayla",
                            style: TextStyle(
                              color: kCreamColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row textCustomTitle({required String title}) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/bookmark.svg",
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: kNavyBlueColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
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

  Future<void> _declareSubmit(String? userID, BuildContext context) async {
    if (ilanBasligiController.text.isNotEmpty &&
        ilanIcerigiController.text.isNotEmpty &&
        ilanKategoriController.text.isNotEmpty) {
      final declare = Provider.of<DeclareViewModel>(context, listen: false);

      DeclareModel _declare = DeclareModel(
          declareTitle: ilanBasligiController.text,
          lawyerId: userID,
          declareCategory: ilanKategoriController.text,
          declareContent: ilanIcerigiController.text,
          declarePrice: ilanUcretController.text);
      bool temp = await declare.saveDeclare(_declare);
      if (temp) {
        ilanBasligiController.text = '';
        ilanIcerigiController.text = '';
        ilanKategoriController.text = '';
        // ignore: use_build_context_synchronously
        await CoolAlert.show(
            backgroundColor: kNavyBlueColor,
            barrierDismissible: false,
            title: 'Başarılı!',
            context: context,
            type: CoolAlertType.success,
            text: 'İlan Başarı ile Yayınlandı...',
            autoCloseDuration: const Duration(seconds: 3),
            confirmBtnText: ' ',
            confirmBtnColor: Colors.white);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        // ignore: use_build_context_synchronously
        await CoolAlert.show(
            backgroundColor: kNavyBlueColor,
            barrierDismissible: false,
            title: 'Hata Oluştu!',
            context: context,
            type: CoolAlertType.error,
            text: 'İlan Yayınlanırken bir hata',
            autoCloseDuration: const Duration(seconds: 3),
            confirmBtnText: ' ',
            confirmBtnColor: Colors.white);
      }
    } else {
      // ignore: use_build_context_synchronously
      await CoolAlert.show(
          backgroundColor: kNavyBlueColor,
          barrierDismissible: false,
          title: 'Hata Oluştu!',
          context: context,
          type: CoolAlertType.error,
          text: 'Lütfen tüm alanları doldurunuz!!!',
          autoCloseDuration: const Duration(seconds: 3),
          confirmBtnText: ' ',
          confirmBtnColor: Colors.white);
    }
  }
}
