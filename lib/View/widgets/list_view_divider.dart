import 'package:flutter/material.dart';
import 'package:listeny/constants/constants.dart';

Padding listViewDivider() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 40.0),
    child: Divider(
      color: themeColor,
    ),
  );
}

// class listViewDivider extends StatelessWidget {
//   const listViewDivider({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 40.0),
//       child: Divider(
//         color: themeColor,
//       ),
//     );
    
//   }
// }