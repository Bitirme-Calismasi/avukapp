import 'dart:io';
import 'package:avukapp/screens/profile/lawyer_profile_edit.dart';
import 'package:avukapp/screens/profile/profile_detail/profile_pages/place_an_ad/screens/place_an_ad_list_page.dart';
import 'package:avukapp/screens/profile/user_profile_edit_page.dart';
import 'package:avukapp/viewmodel/lawyer_view_model.dart';
import 'package:avukapp/viewmodel/storage_view_model.dart';
import 'package:avukapp/viewmodel/user_view_model.dart';
import 'package:avukapp/widgets/social_button.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../constant/constant.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  File? profilImg;
  void _cameraImgUpload() async {
    var newImg = await ImagePicker().pickImage(source: ImageSource.camera);
    Navigator.of(context).pop();
    setState(() {
      profilImg = (File(newImg!.path));
    });
    _profilImgUpdate();
  }

  void _galeriaImgUpload() async {
    var newImg = await ImagePicker().pickImage(source: ImageSource.gallery);
    Navigator.of(context).pop();
    setState(() {
      profilImg = (File(newImg!.path));
    });
    _profilImgUpdate();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserViewModel>(context);
    final _lawyer = Provider.of<LawyerViewModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: kCreamColor,
                      radius: 90,
                      backgroundImage: profilImg == null
                          ? NetworkImage(
                              _user.user!.profilImgURL!.replaceAll('///', '//'))
                          : FileImage(profilImg!) as ImageProvider,
                    ),
                    Positioned(
                        left: 130,
                        top: 130,
                        child: SizedBox(
                          child: IconButton(
                              splashColor: Colors.black,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Profil Fotografı Değiştirme'),
                                      content: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextButton.icon(
                                            onPressed: () {
                                              _cameraImgUpload();
                                            },
                                            icon: const Icon(Icons.camera_alt),
                                            label: const Text('Kamera İle çek'),
                                          ),
                                          TextButton.icon(
                                            onPressed: () {
                                              _galeriaImgUpload();
                                            },
                                            icon: const Icon(Icons.image),
                                            label: const Text('Galeriden Seç'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: kNavyBlueColor,
                                size: 40,
                              )),
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    _user.user!.userName!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 27),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    _user.user!.email!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black54),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SocialButtonWidget(
                    buttonIcon: const Icon(Icons.edit),
                    buttonText: 'Profil Düzenle',
                    buttonColor: kNavyBlueColor,
                    textColor: kCreamColor,
                    buttonHeight: 50,
                    buttonWidth: 250,
                    onPress: () async {
                      var lawyer =
                          await _lawyer.readLawyer(_user.user!.userID!);

                      bool? temp = await Navigator.of(context)
                          .push<bool>(MaterialPageRoute(
                        builder: (context) => _user.user!.isLawyer == 0
                            ? UserProfileEditPage()
                            : LawyerProfileEditPage(lawyer: lawyer),
                      ));
                      if (temp == true) {
                        debugPrint('**************');
                        setState(() {});
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      title: const Text(
                        "AYARLAR",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: _user.user!.isLawyer == 1
                        ? ListTile(
                            leading: const Icon(
                              Icons.receipt_long_outlined,
                              color: Colors.black,
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            title: const Text(
                              "İLANLARIM",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PlaceAnAdList(),
                                  ));
                            },
                          )
                        : ListTile(
                            leading: const Icon(
                              Icons.add_chart,
                              color: Colors.black,
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            title: const Text(
                              "RANDEVULARIM",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {},
                          ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.edit_notifications_sharp,
                        color: Colors.black,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      title: const Text(
                        "BİLDİRİMLER",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _profilImgUpdate() async {
    final user = Provider.of<UserViewModel>(context, listen: false);
    final storage = Provider.of<StorageViewModel>(context, listen: false);
    final lawyer = Provider.of<LawyerViewModel>(context, listen: false);

    var url =
        await storage.uploadFile(user.user!.userID!, 'Profil-img', profilImg!);
    debugPrint(url);
    if (user.user!.isLawyer == 0) {
      await user.updateUserProfileImageUrl(user.user!.userID!, url);
      debugPrint('profik fotografı kayıt oldu sadece user');
      // ignore: use_build_context_synchronously
      await CoolAlert.show(
          backgroundColor: kNavyBlueColor,
          barrierDismissible: false,
          title: 'Güncelleme',
          context: context,
          type: CoolAlertType.success,
          text: ' Başarı ile Güncellendi',
          autoCloseDuration: const Duration(seconds: 2),
          confirmBtnText: ' ',
          confirmBtnColor: Colors.white);
    } else {
      await user.updateUserProfileImageUrl(user.user!.userID!, url);
      await lawyer.updateLawyerProfileImageUrl(user.user!.userID!, url);
      // ignore: use_build_context_synchronously
      await CoolAlert.show(
          backgroundColor: kNavyBlueColor,
          barrierDismissible: false,
          title: 'Güncelleme',
          context: context,
          type: CoolAlertType.success,
          text: ' Başarı ile Güncellendi',
          autoCloseDuration: const Duration(seconds: 2),
          confirmBtnText: ' ',
          confirmBtnColor: Colors.white);
      debugPrint('profik fotografı kayıt oldu sadece avukat');
    }
  }
}
