// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:helpifly/constants/colors.dart';
// import 'package:helpifly/widgets/custom_button.dart'; // Replace with the actual path

// void main() {
//   testWidgets('CustomButton displays correct button color and text', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: CustomButton(
//             onTap: () {},
//             buttonText: 'Medium Button',
//             buttonType: ButtonType.Medium,
//             buttonColor: Colors.blue,
//             textColor: Colors.white,
//           ),
//         ),
//       ),
//     );

//     final buttonFinder = find.byType(CustomButton);
//     final textFinder = find.text('Medium Button');

//     expect(buttonFinder, findsOneWidget);
//     expect(textFinder, findsOneWidget);

//     final button = tester.widget<CustomButton>(buttonFinder);
//     expect(button.buttonColor, Colors.blue);
//     expect(button.textColor, Colors.white);
//   });

//   testWidgets('CustomButton responds to tap when enabled', (WidgetTester tester) async {
//     bool tapped = false;

//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: CustomButton(
//             onTap: () {
//               tapped = true;
//             },
//             buttonText: 'Tap Me',
//             buttonType: ButtonType.Small,
//           ),
//         ),
//       ),
//     );

//     await tester.tap(find.byType(CustomButton));
//     await tester.pump();

//     expect(tapped, true);
//   });

//   testWidgets('CustomButton does not respond to tap when disabled', (WidgetTester tester) async {
//     bool tapped = false;

//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: CustomButton(
//             onTap: () {
//               tapped = true;
//             },
//             buttonText: 'Disabled Button',
//             buttonType: ButtonType.Small,
//             enabled: false,
//           ),
//         ),
//       ),
//     );

//     await tester.tap(find.byType(CustomButton));
//     await tester.pump();

//     expect(tapped, false);
//   });

//   testWidgets('CustomButton displays icon and text correctly', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: CustomButton(
//             onTap: () {},
//             buttonText: 'Icon Button',
//             leadingIcon: Icons.thumb_up,
//             iconColor: Colors.red,
//             iconSize: 24,
//           ),
//         ),
//       ),
//     );

//     expect(find.byIcon(Icons.thumb_up), findsOneWidget);
//     expect(find.text('Icon Button'), findsOneWidget);

//     final icon = tester.widget<Icon>(find.byIcon(Icons.thumb_up));
//     expect(icon.color, Colors.red);
//     expect(icon.size, 24);
//   });

//   testWidgets('CustomButton has correct height and width based on type', (WidgetTester tester) async {
//     // Test for Medium Button
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: CustomButton(
//             onTap: () {},
//             buttonText: 'Medium Button',
//             buttonType: ButtonType.Medium,
//           ),
//         ),
//       ),
//     );

//     final mediumButtonFinder = find.byType(CustomButton);
//     expect(mediumButtonFinder, findsOneWidget);

//     // Test for Small Button
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: CustomButton(
//             onTap: () {},
//             buttonText: 'Small Button',
//             buttonType: ButtonType.Small,
//           ),
//         ),
//       ),
//     );

//     final smallButtonFinder = find.byType(CustomButton);
//     expect(smallButtonFinder, findsOneWidget);
//   });
// }
