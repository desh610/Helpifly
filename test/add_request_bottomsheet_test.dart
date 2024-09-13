// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:helpifly/widgets/add_request_bottomsheet.dart';
// import 'package:helpifly/widgets/custom_button.dart';
// import 'package:helpifly/widgets/custom_dropdown_by_array.dart';

// void main() {
//   group('AddRequestBottomSheet Widget Tests', () {
//     testWidgets('renders AddRequestBottomSheet and its children', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         const MaterialApp(
//           home: Scaffold(
//             body: AddRequestBottomSheet(),
//           ),
//         ),
//       );

//       // Verify that the AddRequestBottomSheet is rendered
//       expect(find.byType(AddRequestBottomSheet), findsOneWidget);

//       // Verify essential widgets are present
//       expect(find.text('New item'), findsOneWidget);
//       expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
//       expect(find.byIcon(Icons.close_rounded), findsOneWidget);

//       // Check if at least one GestureDetector is present where expected
//       expect(find.byType(GestureDetector), findsAtLeastNWidgets(1)); 

//       // Verify CustomDropdownByArray
//       expect(find.byType(CustomDropdownByArray), findsOneWidget);

//       // Verify CustomButton
//       expect(find.byType(CustomButton), findsOneWidget);
//     });
//   });
// }
