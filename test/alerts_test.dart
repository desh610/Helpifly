// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:another_flushbar/flushbar.dart';
// import 'package:helpifly/widgets/alerts.dart';

// void main() {
//   testWidgets('showAlert displays Flushbar with correct message and icon color', (WidgetTester tester) async {
//     // Create a test widget to provide the context for the Flushbar
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: Builder(
//             builder: (context) {
//               // Call showAlert to display the Flushbar
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 showAlert(context, 'Test message', Colors.red);
//               });
//               return Container();
//             },
//           ),
//         ),
//       ),
//     );

//     // Allow some time for the Flushbar to appear
//     await tester.pump(Duration(milliseconds: 500)); // Adjust as needed

//     // Verify the Flushbar is displayed with the correct message
//     expect(find.text('Test message'), findsOneWidget);

//     // Verify the Flushbar icon is displayed
//     final iconFinder = find.byIcon(Icons.info_outline);
//     expect(iconFinder, findsOneWidget);
//   });
// }
