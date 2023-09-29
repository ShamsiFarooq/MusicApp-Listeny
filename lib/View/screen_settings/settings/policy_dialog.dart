import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:listeny/constants/constants.dart';

class PlicyDialog extends StatelessWidget {
  const PlicyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder(
            future: rootBundle
                .loadString('assets/privacy_policy/privacy_policy.md'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Markdown(
                    data: snapshot.data!,
                    styleSheet: MarkdownStyleSheet.fromTheme(
                      ThemeData(
                          textTheme: TextTheme(
                        bodyText2: TextStyle(fontSize: 15, color: textColor),
                      )),
                    ));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
