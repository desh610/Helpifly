import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_new_rounded, color: white),
            ),
            SizedBox(height: 5),
            Text(
              "Search results for\nEducational Institute",
              style: TextStyle(
                color: white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            CustomSearchBar(
              controller: searchTextController,
              onChanged: (p0) {},
            ),
            SizedBox(height: 15),
             BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    return ChipContainer(
                      items: state.categories.take(5).toList(),
                      initialSelectedItem: state.chipSelectedCategory,
                      selectedColor: secondaryColor,
                      unselectedColor: cardColor,
                      selectedTextColor: black,
                      unselectedTextColor: white,
                      onTap: (selectedItem) {
                        BlocProvider.of<AppCubit>(context).setChipSelectedCategory(selectedItem);
                      },
                    );
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
      bottomNavigationBar: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.forum),
                label: 'Forum',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: 0, // Default to Home
            onTap: (index) {
              if (index == 0) {
                Navigator.pop(context); // Navigate back to Home
              } else {
                context.read<AppCubit>().setCurrentTabIndex(index);
                Navigator.pop(context); // Navigate back and set the appropriate tab
              }
            },
            selectedItemColor: grayColor,
            unselectedItemColor: Colors.grey,
            backgroundColor: inCardColor,
          );
        },
      ),
    );
  }
}
