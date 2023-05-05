import 'package:avukapp/viewmodel/declare_view_model.dart';
import 'package:avukapp/viewmodel/user_view_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constant/app_bar_widget.dart';
import '../../../../constant/constant.dart';
import '../../../../manager/navigator_manager.dart';
import '../../../../model/declare.dart';
import '../../../../widgets/custom_card_widget.dart';
import '../../../../widgets/custom_card_widget_button.dart';
import '../ilan_duzenle/ilan_duzenle.dart';

class PlaceAnAdList extends StatefulWidget {
  const PlaceAnAdList({super.key});

  @override
  State<PlaceAnAdList> createState() => _PlaceAnAdListState();
}

class _PlaceAnAdListState extends State<PlaceAnAdList> {
  late List<DeclareModel> declareList;
  bool loading = false;
  Future<void> change() async {
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loading = !loading;
      });
    });
  }

  Future<void> getDeclareForLawyer() async {
    final lawyer = Provider.of<UserViewModel>(context, listen: false);
    final declare = Provider.of<DeclareViewModel>(context, listen: false);
    declareList = await declare.getForIdDeclare(lawyer.user!.userID!);

    for (var i = 0; i < declareList.length; i++) {
      print("$i declare");
    }
  }

  @override
  void initState() {
    super.initState();
    change();
    declareList = [];
    getDeclareForLawyer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appTitle: "İlanlarım"),
      body: Padding(
        padding: const PagePadding.symtcHrztNormal(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: declareList.isEmpty
                  ? const Center(
                      child: Text("Aktif ilan Bulunmamaktadır.."),
                    )
                  : Container(
                      child: loading == true
                          ? ListView.builder(
                              itemCount: declareList.length,
                              itemBuilder: (context, index) {
                                DeclareModel declareModel = declareList[index];
                                return CustomCardWidget(
                                  moodel: declareModel,
                                  solButton: GestureDetector(
                                    onTap: () async {
                                      bool temp = await _deleteDeclare(
                                          declareList[index].declareId!);
                                      if (temp) {
                                        await _showAlert(temp);
                                        declareList.removeAt(index);
                                        setState(() {});
                                      }
                                    },
                                    child: const CustomCardWidgetButton(
                                      buttonTitle: "Sil",
                                    ),
                                  ),
                                  sagButton: GestureDetector(
                                    onTap: () {
                                      NavigatorManager().navigatToWidget(
                                        context,
                                        IlanDuzenle(
                                          model: declareModel,
                                        ),
                                      );
                                    },
                                    child: const CustomCardWidgetButton(
                                      buttonTitle: "Düzenle",
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
          ],
        ),
      ),
    );
  }

  Future<bool> _deleteDeclare(String declareId) async {
    bool temp = false;
    await CoolAlert.show(
      backgroundColor: kNavyBlueColor,
      barrierDismissible: false,
      title: 'İlan siliniyor...',
      context: context,
      type: CoolAlertType.info,
      text: 'İlan Silmek İstediğinden emin misin?',
      cancelBtnText: 'Vazgeç',
      showCancelBtn: true,
      confirmBtnText: 'Onayla',
      confirmBtnColor: kNavyBlueColor,
      onConfirmBtnTap: () async {
        final declare = Provider.of<DeclareViewModel>(context, listen: false);
        temp = await declare.deleteDeclare(declareId);
      },
    );
    return temp;
  }

  Future<void> _showAlert(bool temp) async {
    if (temp) {
      CoolAlert.show(
          backgroundColor: kNavyBlueColor,
          barrierDismissible: false,
          title: 'Başarılı!',
          context: context,
          type: CoolAlertType.success,
          text: 'İlan Başarı ile Silindi...',
          autoCloseDuration: const Duration(seconds: 3),
          confirmBtnText: ' ',
          confirmBtnColor: Colors.white);
    } else {
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
  }
}
