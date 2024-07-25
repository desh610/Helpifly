import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/helper/helper_functions.dart';
import 'package:helpifly/models/item_model.dart';
import 'package:helpifly/widgets/add_review_bottomsheet.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';

class SearchResultsScreen extends StatefulWidget {
  SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController searchTextController = TextEditingController();

  List<String> filteredSearchTextList = [];

  @override
  void initState() {
    super.initState();
    searchTextController.addListener(_filterSearchText);
  }

  void _filterSearchText() {
    final query = searchTextController.text.toLowerCase();
    final allSearchTextList = context.read<AppCubit>().state.searchTextList;
    setState(() {
      filteredSearchTextList = allSearchTextList
          .where((i) => i.toLowerCase().contains(query))
          .toList();
    });
  }

  void _onSuggestionTap(String suggestion) {
    final allCategories = context.read<AppCubit>().state.categories;
    if (allCategories.contains(suggestion)) {
      searchTextController.text = suggestion;
      BlocProvider.of<AppCubit>(context).setChipSelectedCategory(suggestion);
      closeKeyboard(context);
      searchTextController.clear();
      _dismissSuggestions();
    } else {
      final allItems = context.read<AppCubit>().state.items;
      String itemSuggestion =
          allItems.firstWhere((e) => e.title == suggestion).category;

      searchTextController.text = suggestion;
      BlocProvider.of<AppCubit>(context)
          .setChipSelectedCategory(itemSuggestion);
      closeKeyboard(context);
      searchTextController.clear();
      _dismissSuggestions();
    }
  }

  void _dismissSuggestions() {
    setState(() {
      filteredSearchTextList.clear();
    });
  }

    void _showAddReviewBottomSheet(BuildContext context, ItemModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      builder: (BuildContext context) {
        return AddReviewBottomSheet(item: item);
      },
    );
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _dismissSuggestions();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        body: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 35.0),
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
              if (filteredSearchTextList.isNotEmpty)
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Scrollbar(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: filteredSearchTextList.length,
                      itemBuilder: (context, index) {
                        final suggestion = filteredSearchTextList[index];
                        return ListTile(
                          title: Text(
                            suggestion,
                            style: TextStyle(color: black),
                          ),
                          onTap: () => _onSuggestionTap(suggestion),
                        );
                      },
                    ),
                  ),
                ),
              SizedBox(height: 15),
              BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  return ChipContainer(
                    items: state.categories.take(5).toList(),
                    selectedItem: state.chipSelectedCategory,
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
                  List<ItemModel> filteredItems = state.items
                      .where((e) => e.category == state.chipSelectedCategory)
                      .toList()
                    ..sort((a, b) => b.credit
                        .compareTo(a.credit)); // Sort by credit, descending

                  if (filteredItems.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          ItemModel item = filteredItems[index];
                          return GestureDetector(
                            onTap: () => _showAddReviewBottomSheet(context, item),
                            child: Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        style: TextStyle(
                                            color: white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 140),
                        child: Text(
                          "No available results",
                          style: TextStyle(
                            color: lightGrayColor.withOpacity(0.8),
                            letterSpacing: 1,
                          ),
                        ),
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
                  icon: Icon(Icons.web),
                  label: 'URL',
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
              currentIndex: state.currentTabIndex ?? 0,
              onTap: (index) {
                if (index == 0) {
                  Navigator.pop(context);
                } else {
                  context.read<AppCubit>().setCurrentTabIndex(index);
                  Navigator.pop(context);
                }
              },
              selectedItemColor: grayColor,
              unselectedItemColor: Colors.grey,
              backgroundColor: inCardColor,
              type: BottomNavigationBarType.fixed
            );
          },
        ),
      ),
    );
  }
}
