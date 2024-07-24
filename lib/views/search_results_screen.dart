import 'package:flutter/material.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';

class SearchResultsScreen extends StatelessWidget {
  SearchResultsScreen({super.key});

  final TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search results for\nEducational Institute",
              style: TextStyle(
                color: white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            CustomSearchBar(controller: searchTextController, onChanged: (p0) {
              
            },),
            SizedBox(height: 15),
            ChipContainer(
              items: [
                "Institutes",
                "Vehicles",
                "Smartphones",
                "Internets",
                "Telecom Providers"
              ],
              initialSelectedItem: "Institutes",
              selectedColor: secondaryColor,
              unselectedColor: cardColor,
              selectedTextColor: black,
              unselectedTextColor: white,
              onTap: (selectedItem) {
                print('Selected: $selectedItem');
              },
            ),
            SizedBox(height: 15),
            Text(
              "Top educational institute",
              style: TextStyle(
                fontSize: 20,
                color: white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: cardColor,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
        bottomNavigationBar: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        color: inCardColor,
      ),
    );
  }
}
