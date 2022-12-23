import 'package:flutter/material.dart';
import 'package:listeny/screens/settings/policy_dialog.dart';
import 'package:listeny/screens/settings/terms_and_condition.dart';
import '../../style/constant.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool value = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: logoBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            height15,
            headText(text: 'Settings'),

            Container(
              margin: const EdgeInsets.only(
                  top: 15, left: 20, right: 20, bottom: 0),
              decoration: BoxDecoration(
                color: color2,
                borderRadius: BorderRadius.circular(50),
              ),
              child: ListTile(
                title: Text(
                  'Privacy & Policy',
                  style: TextStyle(color: color4),
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
                color: color2,
                borderRadius: BorderRadius.circular(50),
              ),
              child: ListTile(
                title: Text(
                  'Terms & Conditions',
                  style: TextStyle(color: color4),
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

            // Container(
            //   margin: const EdgeInsets.only(
            //       top: 15, left: 20, right: 20, bottom: 0),
            //   decoration: BoxDecoration(
            //     color: color2,
            //     borderRadius: BorderRadius.circular(50),
            //   ),
            //   child: ListTile(
            //     title: Text(
            //       'Notification',
            //       style: TextStyle(color: color4),
            //     ),
            //     trailing: Switch.adaptive(
            //         activeColor: color3,
            //         inactiveThumbColor: color1,
            //         value: value,
            //         onChanged: (value) => setState(() => this.value = value)),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //   ),
            // ),

            Container(
              margin: const EdgeInsets.only(
                  top: 15, left: 20, right: 20, bottom: 0),
              decoration: BoxDecoration(
                color: color2,
                borderRadius: BorderRadius.circular(50),
              ),
              child: ListTile(
                title: Text(
                  'About',
                  style: TextStyle(color: color4),
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
              children: [
                Text(
                  'Version  -  1.0',
                  style: TextStyle(color: color3, fontSize: 16),
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
      style: TextStyle(fontSize: 35, color: color4, fontFamily: 'Caveat'),
    );
  }

  AppBar logoBar() {
    return AppBar(
      backgroundColor: color2,
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
        image: AssetImage('assets/img/ListenyLogo1.png'),
      ),
      applicationVersion: '1.0',
      applicationLegalese: 'Developed By \nShamseena M A',
    );
  }
}
