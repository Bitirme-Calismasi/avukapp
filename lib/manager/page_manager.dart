import 'package:avukapp/model/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constant/constant.dart';
import '../screens/home/home_page.dart';
import '../screens/login/login.dart';
import '../screens/message/message_page.dart';
import '../screens/notification/notification_page.dart';
import '../screens/profile/profile_detail/about_detail/about.dart';
import '../screens/profile/profile_detail/language_detail/language_settings.dart';
import '../screens/profile/profile_detail/notification_detail/notification.dart';
import '../screens/profile/profile_detail/profile_pages/place_an_ad/place_an_ad_body.dart';
import '../screens/profile/profile_detail/terms_conditions_detail/terms_conditions.dart';
import '../screens/profile/profile_page.dart';
import '../viewmodel/user_view_model.dart';
import 'navigator_manager.dart';

// ignore: must_be_immutable
class MyPageManager extends StatefulWidget {
  MyPageManager({super.key});

  @override
  State<MyPageManager> createState() => _MyPageManagerState();
}

class _MyPageManagerState extends State<MyPageManager> {
  int selectinIndex = 0;
  final double _bottomBarHeight = 60;
  final int _duration = 600;
  final double _animateContainerWitdth = 74;
  NavigatorManager pagePushManager = NavigatorManager();
  @override
  void initState() {
    super.initState();
  }

  String getAppName(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return "Ana Sayfa";

      case 1:
        return "Mesajlar";

      case 2:
        return "Bildirimler";

      case 3:
        return "Profil Sayfası";
      default:
        return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserViewModel>(context, listen: false);

    PageController myPage = PageController(initialPage: selectinIndex);
    return Scaffold(
      drawer: selectinIndex == 0
          ? drawerHamburgerMenu(
              userProvider.user!,
              context,
              userProvider,
            )
          : null,
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          getAppName(selectinIndex),
          // style: const TextStyle(
          //   fontSize: 24,
          //   fontWeight: FontWeight.bold,
          //   color: kCreamColor,
          // ),
          style: GoogleFonts.cutiveMono(
            color: kCreamColor,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: kNavyBlueColor,
        centerTitle: true,
      ),
      body: PageView(
        // physics: const NeverScrollableScrollPhysics(),
        controller: myPage,
        onPageChanged: (value) {
          setState(() {
            selectinIndex = value;
          });
        },
        children: const [
          MyHomePage(),
          MyMessagePage(),
          MyNotificationPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: homeBottomBar(myPage),
    );
  }

  Drawer drawerHamburgerMenu(
    UserModel user,
    BuildContext context,
    UserViewModel userViewModel,
  ) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              user.userName!,
              style: const TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              user.email!,
              style: const TextStyle(color: Colors.black),
            ),
            currentAccountPicture: SizedBox(
              width: 100,
              height: 50,
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.profilImgURL ?? ''),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: NetworkImage(
                    "https://i.pinimg.com/736x/1a/61/10/1a611036f4275ca78c58277e1fb260b6.jpg",
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          if (user.isLawyer == 1)
            ListTile(
              leading: const Icon(
                Icons.receipt_long_outlined,
                color: Colors.black,
              ),
              title: const Text("İlan Ayarları"),
              onTap: () {
                pagePushManager.navigatToWidget(
                  context,
                  const PlaceAnAdBody(),
                );
              },
            ),
          ListTile(
            leading: const Icon(
              Icons.edit_notifications_sharp,
              color: Colors.black,
            ),
            title: const Text("Bildirim Ayarları"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.language,
              color: Colors.black,
            ),
            title: const Text("Dil Ayarları"),
            onTap: () {
              pagePushManager.navigatToWidget(
                context,
                const LanguageSettingsPage(),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.account_box_outlined,
              color: Colors.black,
            ),
            title: const Text("Hakkında"),
            onTap: () {
              pagePushManager.navigatToWidget(
                context,
                const AboutPage(),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.rule_folder,
              color: Colors.black,
            ),
            title: const Text("Şartlar & Koşullar"),
            onTap: () {
              pagePushManager.navigatToWidget(
                context,
                const TermsConditionsPage(),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: const Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            title: const Text("Exit"),
            onTap: () async {
              // showExitPopup(context);
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: SizedBox(
                      height: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Do you want to exit?"),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    userViewModel.singOut();
                                  },
                                  style: ElevatedButton.styleFrom(),
                                  child: const Text("Yes"),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    print('no selected');
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      //primary: ColorConstants.instance.flower,
                                      ),
                                  child: const Text(
                                    "No",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Padding homeBottomBar(PageController myPage) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
          color: kNavyBlueColor,
        ),
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: _bottomBarHeight,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: _duration),
                  width: _animateContainerWitdth,
                  decoration: BoxDecoration(
                    color: selectinIndex == 0 ? kCreamColor : null,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        selectinIndex = 0;
                        myPage.jumpToPage(selectinIndex);
                      });
                    },
                    icon: Icon(
                      Icons.home,
                      color: selectinIndex == 0 ? kNavyBlueColor : kCreamColor,
                      size: 32,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: _duration),
                  width: _animateContainerWitdth,
                  decoration: BoxDecoration(
                    color: selectinIndex == 1 ? kCreamColor : null,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectinIndex = 1;
                            myPage.jumpToPage(selectinIndex);
                          });
                        },
                        icon: Icon(
                          Icons.message,
                          color:
                              selectinIndex == 1 ? kNavyBlueColor : kCreamColor,
                          size: 32,
                        ),
                      ),
                      Positioned(
                        bottom: 26,
                        left: 50,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: kWineRedColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "1",
                              style: TextStyle(color: kCreamColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: _duration),
                  width: _animateContainerWitdth,
                  decoration: BoxDecoration(
                    color: selectinIndex == 2 ? kCreamColor : null,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        selectinIndex = 2;
                        myPage.jumpToPage(selectinIndex);
                      });
                    },
                    icon: Icon(
                      Icons.notifications,
                      color: selectinIndex == 2 ? kNavyBlueColor : kCreamColor,
                      size: 32,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: _duration),
                  width: _animateContainerWitdth,
                  decoration: BoxDecoration(
                    color: selectinIndex == 3 ? kCreamColor : null,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        selectinIndex = 3;
                        myPage.jumpToPage(selectinIndex);
                      });
                    },
                    icon: Icon(
                      Icons.person,
                      color: selectinIndex == 3 ? kNavyBlueColor : kCreamColor,
                      size: 32,
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

  Future showExitPopup(context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Do you want to exit?"),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print('yes selected');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(),
                        child: const Text("Yes"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print('no selected');
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            //primary: ColorConstants.instance.flower,
                            ),
                        child: const Text(
                          "No",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
