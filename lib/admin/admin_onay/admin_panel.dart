import 'package:avukapp/constant/constant.dart';
import 'package:avukapp/viewmodel/lawyer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant/app_bar_widget.dart';
import '../../model/lawyer.dart';
import '../../screens/login/login.dart';
import '../../widgets/custom_button_widget.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  bool isInited = true;
  // Appbar ve bottom barın toplam yüksekliği
  double totalHeight = 170;

  late List<LawyerModel> allLawyer;

  Future<void> getAllLawyer() async {
    var lavyer = Provider.of<LawyerViewModel>(context, listen: false);
    var lw = await lavyer.getAllLawyer();

    allLawyer = lw;
  }

  void initedChange() async {
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isInited = !isInited;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    allLawyer = [];
    initedChange();
    getAllLawyer();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height - totalHeight;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Admin Paneli")),
        backgroundColor: kNavyBlueColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          },
          icon: Icon(Icons.exit_to_app),
        ),
      ),
      body: isInited == false
          ? Container(
              height: screenHeight,
              color: Colors.black12,
              child: ListView.builder(
                itemCount: allLawyer.length,
                itemBuilder: (context, index) {
                  LawyerModel model = allLawyer[index];

                  return Container(
                    margin: const EdgeInsets.all(8),
                    color: allLawyer[index].isActive == false
                        ? Colors.red
                        : Colors.green,
                    height: 140,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: kCreamColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: _textStyle(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: _bilgilerMethod(model),
                        ),
                        Expanded(
                          flex: 2,
                          child: _buttonMethod(model),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: kNavyBlueColor,
              ),
            ),
      bottomSheet: const CustomButtonWidget(
        buttonName: "Bildirim Gönder",
      ),
    );
  }

  Column _buttonMethod(LawyerModel model) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              color: kCreamColor,
              child: TextButton(
                child: Center(
                    child: Text(
                  "Onay",
                  style: _textStyle(),
                )),
                onPressed: () async {
                  debugPrint(model.userName);
                  await _activeControlAdmin(model.lawyerID, true);
                  setState(() {
                    model.isActive = true;
                  });
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              color: kCreamColor,
              child: TextButton(
                child: Center(
                    child: Text(
                  "Ret",
                  style: _textStyle(),
                )),
                onPressed: () async {
                  debugPrint(model.userName);
                  await _activeControlAdmin(model.lawyerID, false);
                  setState(() {
                    model.isActive = false;
                  });
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Column _bilgilerMethod(LawyerModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Ad - Soyadı",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          model.userName ?? "Ad Girilmemiş",
          style: const TextStyle(
            color: kNavyBlueColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 8,
          ),
          child: SizedBox(
            height: 2,
            child: Container(
              color: kCreamColor,
            ),
          ),
        ),
        const Text(
          "Baro Numarası",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          model.lawyerBaroNumber,
          style: const TextStyle(
            color: kNavyBlueColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  TextStyle _textStyle() {
    return const TextStyle(
      fontSize: 18,
      color: kNavyBlueColor,
      fontWeight: FontWeight.bold,
    );
  }

  Future<bool> _activeControlAdmin(String lawyerID, bool active) async {
    final lawyer = Provider.of<LawyerViewModel>(context, listen: false);
    bool temp = await lawyer.lawyerActiveControlAdmin(lawyerID, active);
    debugPrint('BU AVUKATIN : $lawyerID  AKTİFLİK DURUMU $temp');
    return temp;
  }
}
