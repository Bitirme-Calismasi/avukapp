import 'package:avukapp/constant/constant.dart';
import 'package:avukapp/model/appointment.dart';
import 'package:avukapp/model/declare.dart';
import 'package:avukapp/viewmodel/declare_view_model.dart';
import 'package:avukapp/viewmodel/user_view_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../constant/app_bar_widget.dart';
import '../../../service/stripe_service.dart';
import '../../exception/login-exception.dart';

class AppointmentPage extends StatefulWidget {
  final DeclareModel declare;

  const AppointmentPage({required this.declare, super.key});
  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  // final String _appointmentIcon = "assets/icons/profile_date.svg";
  //final String _clockIcon = "assets/icons/profile_clock.svg";
  final String _editIcon = "assets/icons/profile_design.svg";
  final TextEditingController descriptionController = TextEditingController();

  // randevu tipi seçimi için kullanılıyor bunu daha sonra -1 yapabilirsin.
  @override
  void initState() {
    super.initState();
    descriptionController.text = 'deneme Açıklaması';
  }

  bool? acceptTerms = false;

  // randevu tipi değişimi için kullanılıyor.
  // void changeType() {
  //   setState(() {
  //     if (randevuTipi == 0) {
  //       randevuTipi = 1;
  //     } else {
  //       randevuTipi = 0;
  //     }
  //   });
  // }

  // Tarih Seçimi
  DateTime selectedDate = DateTime.now();
  final firstDate = DateTime(2010, 1);
  final lastDate = DateTime(2024, 12);

  Future<void> getPriceForAppointment(DeclareModel declare) async {
    var items = [
      {
        "productPrice": int.parse(declare.declarePrice.toString()),
        "productName": "  ${declare.declareTitle.toString()} Randevusu",
        "qty": 1
      },
    ];
    var paymentResult = await StripeService.stripePaymentCheckout(
      items,
      500,
      context,
      mounted,
      onSuccess: () async {
        try {
          print("Appointment saved successfully");
          await saveAppointment();
          Navigator.pop(context);
        } catch (e) {
          print("Error saving appointment: $e");
          // Handle the error appropriately (e.g., show an error message to the user)
        }
      },
      onCancel: () {
        print("CANCEL");
        Navigator.pop(context);
      },
      onError: (e) {
        print(" ERROR: ${e.toString()}");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const CustomAppBar(
        appTitle: "Randevu Al",
      ),
      body: Padding(
        padding: const PagePadding.symtcHrztHigh(),
        child: SizedBox(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: 100,
                //   child: Row(
                //     children: [
                //       Expanded(
                //         flex: 1,
                //         child: SvgPicture.asset(
                //           _appointmentIcon,
                //         ),
                //       ),
                //       Expanded(
                //         flex: 4,
                //         child: Text(
                //           widget.declare.declareTitle.toString(),
                //           textAlign: TextAlign.center,
                //           style: const TextStyle(
                //             color: kNavyBlueColor,
                //             fontSize: 22,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                const SizedBox(height: 15),
                customSubjectTitle(titlee: "Randevu Bilgileri"),
                const SizedBox(height: 10),

                Container(
                  width: pageWidth,
                  color: kCreamColor,
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "İlan Başlığı",
                                    style: textStyleLeft(),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.declare.declareTitle.toString(),
                                    style: textStyleRight(),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "İlan İçeriği",
                                    style: textStyleLeft(),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.declare.declareContent.toString(),
                                    style: textStyleRight(),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "İlan Ücreti",
                                    style: textStyleLeft(),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${widget.declare.declarePrice.toString()} Tl",
                                    style: textStyleRight(),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
                // Divider(
                //   thickness: 2.5,
                //   color: kNavyBlueColor.withOpacity(0.5),
                // ),
                const SizedBox(height: 10),
                customSubjectTitle(titlee: "Randevu İşlemleri Sırası"),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "1) Randevu alacağınız avukatı doğru seçtiğinizden emin olun.",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "2) Randevu şartlarını okuyunuz ve kabul ediniz.",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "3) Randevu oluşturunuz.",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: pageWidth * 0.60,
                    child: const Text(
                      "Randevu tarihleri avukatlar tarafından belirlenmektedir.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 1.5,
                        wordSpacing: 4,
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    debugPrint('Randevu sayfasına yönlendiriliyor...');
                    await getPriceForAppointment(widget.declare);
                    //await saveAppointment();
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kNavyBlueColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Ödeme Yap",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cutiveMono(
                            color:
                                acceptTerms == true ? kCreamColor : Colors.grey,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        _openTerms(context);
                      },
                      child: const Text(
                        "Şartları Oku",
                        style: TextStyle(
                          color: kNavyBlueColor,
                          decoration: TextDecoration.underline,
                          decorationThickness: 2,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Checkbox(
                      value: acceptTerms,
                      activeColor: kNavyBlueColor,
                      checkColor: kCreamColor,
                      onChanged: (value) {
                        setState(() {
                          acceptTerms = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle textStyleRight() {
    return const TextStyle(
      color: kBlackColor,
      fontSize: 15,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle textStyleLeft() {
    return const TextStyle(
      color: kNavyBlueColor,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  _openTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Buradaki şartlar kabul ediliyor."),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  kNavyBlueColor,
                ),
              ),
              child: const Text("Kapat"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // todo: Aynı olan konu başlıkları.
  Row customSubjectTitle({required String titlee}) {
    return Row(
      children: [
        SvgPicture.asset(
          _editIcon,
          width: 25,
          height: 25,
        ),
        const SizedBox(width: 15),
        Text(
          titlee,
          style: customTextStyle(textSize: 16),
        ),
      ],
    );
  }

  // todo: Randevu tarihinin seçilmesi
  // _openDatePicker(BuildContext context) async {
  //   final DateTime? date = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: firstDate,
  //     lastDate: lastDate,
  //   );

  //   if (date != null) {
  //     setState(() {
  //       selectedDate = date;
  //     });
  //   }
  // }

  // _openClock(BuildContext context) async {
  //   String? mySaat = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       int selectedClock = -1;

  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //         icon: Text(
  //           "Saat Seçiniz",
  //           style: customTextStyle(textSize: 20),
  //         ),
  //         content: StatefulBuilder(
  //           builder: (context, setState) {
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //               child: SizedBox(
  //                 width: 400,
  //                 height: 200,
  //                 child: GridView.builder(
  //                   itemCount: clockItems.length,
  //                   gridDelegate:
  //                       const SliverGridDelegateWithFixedCrossAxisCount(
  //                     crossAxisCount: 2,
  //                     childAspectRatio: 3,
  //                     crossAxisSpacing: 10,
  //                     mainAxisSpacing: 6,
  //                   ),
  //                   itemBuilder: (context, index) {
  //                     return GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           selectedClock = index;
  //                         });
  //                       },
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           color: kCreamColor,
  //                           borderRadius: BorderRadius.circular(4),
  //                           border: Border.all(
  //                             color: selectedClock == index
  //                                 ? kWineRedColor
  //                                 : Colors.grey.shade500,
  //                             width: 2,
  //                           ),
  //                         ),
  //                         child: Center(
  //                             child: Text(
  //                           clockItems[index],
  //                         )),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //         actions: [
  //           Row(
  //             children: [
  //               const SizedBox(width: 20),
  //               Expanded(
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   style: ButtonStyle(
  //                     backgroundColor: MaterialStateProperty.all(
  //                       kNavyBlueColor,
  //                     ),
  //                   ),
  //                   child: const Text("Çıkış"),
  //                 ),
  //               ),
  //               const SizedBox(width: 20),
  //               Expanded(
  //                 child: ElevatedButton(
  //                   style: ButtonStyle(
  //                     backgroundColor: MaterialStateProperty.all(
  //                       kNavyBlueColor,
  //                     ),
  //                   ),
  //                   child: const Text("Onayla"),
  //                   onPressed: () {
  //                     if (selectedClock != -1) {
  //                       Navigator.pop(
  //                         context,
  //                         clockItems[selectedClock],
  //                       );
  //                     }
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(width: 20),
  //             ],
  //           )
  //         ],
  //         actionsAlignment: MainAxisAlignment.center,
  //       );
  //     },
  //   );
  //   if (mySaat != null) {
  //     // print(mySaat);

  //     setState(() {
  //       selectedClockx = mySaat;
  //     });
  //   } else {
  //     mySaat == "Boş";
  //     // print(mySaat);
  //   }
  // }

  // Container appntmntTypeSelection({
  //   required String buttonName,
  //   required int selectedIndex,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 20),
  //     decoration: BoxDecoration(
  //       color: kCreamColor,
  //       borderRadius: BorderRadius.circular(4),
  //       border: Border.all(
  //         width: 2.2,
  //         color: randevuTipi == selectedIndex
  //             ? Colors.green
  //             : kNavyBlueColor.withOpacity(0.6),
  //       ),
  //     ),
  //     child: Text(
  //       buttonName,
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //         fontSize: 15,
  //         color: randevuTipi == selectedIndex
  //             ? Colors.green
  //             : kNavyBlueColor.withOpacity(0.6),
  //         fontWeight: FontWeight.w400,
  //       ),
  //     ),
  //   );
  // }

  TextStyle customTextStyle({required double textSize}) {
    return TextStyle(
      color: kNavyBlueColor,
      fontSize: textSize,
      fontWeight: FontWeight.w500,
    );
  }

  Future<void> saveAppointment() async {
    try {
      final user = Provider.of<UserViewModel>(context, listen: false);
      final declare = Provider.of<DeclareViewModel>(context, listen: false);

      if (user.user!.userID == widget.declare.lawyerId) {
        Fluttertoast.showToast(
            msg: 'İlan sahibi , kendi için randevu talep edemez',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
      List<AppointmentModel> getList =
          await declare.getForIdAppointment(user.user!.userID!);
      bool temp = true;
      bool temp2 = true;
      for (var element in getList) {
        temp = element.isActive ?? false;
        if (user.user!.userID == element.userID &&
            widget.declare.lawyerId == element.lawyerID) {
          temp2 = false;
        }
      }
      if (temp) {
        if (temp2) {
          AppointmentModel appo = AppointmentModel(
              userID: user.user!.userID,
              lawyerID: widget.declare.lawyerId,
              description: descriptionController.text);
          bool temp = await declare.saveAppointment(appo);
          if (temp) {
            await getPriceForAppointment(widget.declare);
          }
          if (temp) {
            // ignore: use_build_context_synchronously
            await CoolAlert.show(
                backgroundColor: kNavyBlueColor,
                barrierDismissible: false,
                title: 'Başarılı',
                context: context,
                type: CoolAlertType.success,
                text: 'Talebiniz Avukata İletilmiştir',
                autoCloseDuration: const Duration(seconds: 3),
                confirmBtnText: ' ',
                confirmBtnColor: Colors.white);
            //  RANDEVULARIM SAYFASI OLUŞTURULDUKTAN SONRA ORAYA YÖNLENDİRİLİCEK
            // ignore: use_build_context_synchronously
          }
        } else {
          // ignore: use_build_context_synchronously
          await CoolAlert.show(
              backgroundColor: kNavyBlueColor,
              barrierDismissible: false,
              title: 'Uyarı',
              context: context,
              type: CoolAlertType.info,
              text: 'Bu avukat dan gerçekleşmemiş randevunuz vardır...',
              autoCloseDuration: const Duration(seconds: 2),
              confirmBtnText: ' ',
              confirmBtnColor: Colors.white);
        }
      } else {
        // ignore: use_build_context_synchronously
        await CoolAlert.show(
            backgroundColor: kNavyBlueColor,
            barrierDismissible: false,
            title: 'Uyarı',
            context: context,
            type: CoolAlertType.info,
            text:
                'Onaylanmayı bekleyen Randevunuz olduğu için Şuan randevu oluşturamazsınız...',
            autoCloseDuration: const Duration(seconds: 2),
            confirmBtnText: ' ',
            confirmBtnColor: Colors.white);
      }
    } on FirebaseAuthException catch (e) {
      String temp = LoginException.exception(e.toString());
      Fluttertoast.showToast(
          msg: temp,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red.shade300,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  /*
  GestureDetector(
                    onTap: acceptTerms == true
                        ? () {
                            NavigatorManager().navigatToWidget(
                              context,
                              const PaymentPage(),
                            );
                          }
                        : null,
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: kCreamColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: kNavyBlueColor.withOpacity(0.6),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                color: kNavyBlueColor.withOpacity(0.4),
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "$selectedDate".split(" ")[0],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: kCreamColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "$selectedClockx",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: kCreamColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                "Onayla",
                                style: TextStyle(
                                  color: kNavyBlueColor.withOpacity(0.6),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
   */
}
 // SizedBox(
                  //   width: pageWidth,
                  //   height: pageHeight * 0.1,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         flex: 1,
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             if (randevuTipi != 0) {
                  //               changeType();
                  //             }
                  //           },
                  //           child: appntmntTypeSelection(
                  //             buttonName: "Arama ile Görüşme",
                  //             selectedIndex: 0,
                  //           ),
                  //         ),
                  //       ),
                  //       const SizedBox(width: 10),
                  //       Expanded(
                  //         flex: 1,
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             if (randevuTipi != 1) {
                  //               changeType();
                  //             }
                  //           },
                  //           child: appntmntTypeSelection(
                  //             buttonName: "Video ile Görüşme",
                  //             selectedIndex: 1,
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 40),
                  // customSubjectTitle(
                  //   titlee: "Randevu Tarihini ve Saatini Seçin",
                  // ),

// Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         OutlinedButton.icon(
                  //           style: ButtonStyle(
                  //             padding: MaterialStateProperty.all(
                  //               const EdgeInsets.symmetric(
                  //                 vertical: 10,
                  //                 horizontal: 20,
                  //               ),
                  //             ),
                  //           ),
                  //           label: Text(
                  //             "Tarih Seçin",
                  //             style: customTextStyle(textSize: 16),
                  //           ),
                  //           icon: SvgPicture.asset(
                  //             _appointmentIcon,
                  //             width: 28,
                  //             height: 28,
                  //           ),
                  //           onPressed: () => _openDatePicker(context),
                  //         ),
                  //       ],
                  //     ),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         OutlinedButton.icon(
                  //           style: ButtonStyle(
                  //             padding: MaterialStateProperty.all(
                  //               const EdgeInsets.symmetric(
                  //                 vertical: 10,
                  //                 horizontal: 20,
                  //               ),
                  //             ),
                  //           ),
                  //           label: Text(
                  //             "Saat Seçin",
                  //             style: customTextStyle(textSize: 16),
                  //           ),
                  //           icon: SvgPicture.asset(
                  //             _clockIcon,
                  //             width: 26,
                  //             height: 26,
                  //           ),
                  //           onPressed: () => _openClock(context),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),