import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/models/item_model.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';

class SearchResultsScreen extends StatelessWidget {
  SearchResultsScreen({super.key});

  final TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 35),
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
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return Text(
                  "Search results for\n${state.chipSelectedCategory}",
                  style: TextStyle(
                    color: white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            SizedBox(height: 15),
            CustomSearchBar(
              controller: searchTextController,
              onChanged: (text) {},
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
                    BlocProvider.of<AppCubit>(context)
                        .setChipSelectedCategory(selectedItem);
                  },
                );
              },
            ),
            SizedBox(height: 15),
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return Text(
                  "Top ${state.chipSelectedCategory}",
                  style: TextStyle(
                    fontSize: 20,
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            SizedBox(height: 6),
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                // Filter and sort items based on credit
                List<ItemModel> filteredItems = state.items
                    .where((e) => e.category == state.chipSelectedCategory)
                    .toList()
                  ..sort((a, b) => b.credit
                      .compareTo(a.credit)); // Sort by credit, descending

                if (filteredItems.length != 0) {
                  return Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        ItemModel item = filteredItems[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: cardColor,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://i.pinimg.com/280x280_RS/56/ee/fe/56eefe4d7953d6cd43089ef54766fc2d.jpg',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              SizedBox(width: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      color: white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    item.title2,
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(color: white, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 140),
                      child: Text("No available results", style: TextStyle(color: lightGrayColor.withOpacity(0.8), letterSpacing: 1, ),),
                    ),
                  );
                }
              },
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
                Navigator.pop(
                    context); // Navigate back and set the appropriate tab
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
