// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:helpifly/widgets/category_chips.dart';

// void main() {
//   testWidgets('ChipContainer renders with correct colors and text', (WidgetTester tester) async {
//     // Create a test widget
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: ChipContainer(
//             items: ['Chip 1', 'Chip 2', 'Chip 3'],
//             selectedItem: 'Chip 2',
//             selectedColor: Colors.blue,
//             unselectedColor: Colors.grey,
//             selectedTextColor: Colors.white,
//             unselectedTextColor: Colors.black,
//             onTap: (item) {},
//           ),
//         ),
//       ),
//     );

//     // Check the colors and text for each chip
//     expect(
//       (tester.firstWidget(find.text('Chip 1')) as Text).style?.color,
//       equals(Colors.black),
//     );
//     expect(
//       (tester.firstWidget(find.text('Chip 2')) as Text).style?.color,
//       equals(Colors.white),
//     );
//     expect(
//       (tester.firstWidget(find.text('Chip 3')) as Text).style?.color,
//       equals(Colors.black),
//     );

  
//   });

//   testWidgets('ChipContainer invokes onTap callback with correct item', (WidgetTester tester) async {
//     // Define the callback variable to check later
//     String? tappedItem;
//     void onTap(String item) {
//       tappedItem = item;
//     }

//     // Create a test widget
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: ChipContainer(
//             items: ['Chip 1', 'Chip 2', 'Chip 3'],
//             selectedItem: 'Chip 2',
//             selectedColor: Colors.blue,
//             unselectedColor: Colors.grey,
//             selectedTextColor: Colors.white,
//             unselectedTextColor: Colors.black,
//             onTap: onTap,
//           ),
//         ),
//       ),
//     );

//     // Tap on 'Chip 1' and trigger the callback
//     await tester.tap(find.text('Chip 1'));
//     await tester.pump(); // Rebuild the widget tree

//     // Check if the onTap callback was called with the correct item
//     expect(tappedItem, equals('Chip 1'));
//   });
// }
