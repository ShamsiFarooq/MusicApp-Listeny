import 'package:flutter/material.dart';
import 'package:listeny/View/screen_settings/settings/policy_dialog.dart';
import 'package:listeny/View/screen_settings/settings/terms_and_condition.dart';
import 'package:listeny/constants/constants.dart';

class ScreenSettings extends StatelessWidget {
  ScreenSettings({super.key});

  bool value = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPrimary,
      appBar: logoBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            kHeight10,
            headText(text: 'Settings'),

            Container(
              margin: const EdgeInsets.only(
                  top: 15, left: 20, right: 20, bottom: 0),
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: ListTile(
                title: const Text(
                  'Privacy & Policy',
                  style: TextStyle(color: textColor),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PlicyDialog()));
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 15, left: 20, right: 20, bottom: 0),
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: ListTile(
                title: const Text(
                  'Terms & Conditions',
                  style: TextStyle(color: textColor),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TermsAndConditions()));
                },
              ),
            ),

            Container(
              margin: const EdgeInsets.only(
                  top: 15, left: 20, right: 20, bottom: 0),
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: ListTile(
                title: const Text(
                  'About',
                  style: TextStyle(color: textColor),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AboutPage()));
                },
              ),
            ),
            const SizedBox(
              height: 300,
            ),
            Column(
              children: const [
                Text(
                  'Version  -  1.0',
                  style: TextStyle(color: authColor, fontSize: 16),
                ),
              ],
            )
            // Text('Version 0.0.1',
            //   style: TextStyle(color: color3),)
          ],
        ),
      ),
    );
  }

  Text headText({required String text}) {
    return Text(
      text,
      style:
          const TextStyle(fontSize: 35, color: textColor, fontFamily: 'Caveat'),
    );
  }

  AppBar logoBar() {
    return AppBar(
      backgroundColor: themeColor,
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LicensePage(
      applicationName: 'Listeny',
      applicationIcon: Image(
        image: AssetImage('assets/img/Listeny.png'),
      ),
      applicationVersion: '2.0',
      applicationLegalese: 'Developed By \nShamseena M A',
    );
  }
}
