import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/helper/helper_functions.dart';
import 'package:helpifly/models/item_model.dart';
import 'package:helpifly/views/search_results_screen.dart';
import 'package:helpifly/widgets/add_review_bottomsheet.dart';
import 'package:helpifly/widgets/skeletons.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchTextController = TextEditingController();
  List<String> filteredSearchTextList = [];

  @override
  void initState() {
    super.initState();
    context.read<AppCubit>().loadItems();
    context.read<AppCubit>().loadRequests();
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
    if(allCategories.contains(suggestion)){

    print(suggestion);
    searchTextController.text = suggestion;
    setState(() {
      filteredSearchTextList.clear();
    });
    BlocProvider.of<AppCubit>(context).setChipSelectedCategory(suggestion);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchResultsScreen()),
    );
    // DO NOT CHANGE BELOW CLEARING ORDER
    closeKeyboard(context);
    searchTextController.clear();
    _dismissSuggestions();

    }else{
      final allItems = context.read<AppCubit>().state.items;
      String itemSuggestion = allItems.firstWhere((e) => e.title == suggestion).category;

    searchTextController.text = suggestion;
    setState(() {
      filteredSearchTextList.clear();
    });
    BlocProvider.of<AppCubit>(context).setChipSelectedCategory(itemSuggestion);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchResultsScreen()),
    );
    // DO NOT CHANGE BELOW CLEARING ORDER
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
        backgroundColor: primaryColor,
        body: Container(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<AppCubit, AppState>(
                      builder: (context, state) {
                        final userInfo = state.userInfo;
                        return Text(
                          "Welcome ${userInfo.firstName},",
                          style: const TextStyle(
                            color: white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.6,
                          ),
                        );
                      },
                    ),
                    const Icon(Icons.notifications_rounded, color: white),
                  ],
                ),
                const Text(
                  "Find the best\nproduct for you!",
                  style: TextStyle(
                    color: white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  children: [
                    CustomSearchBar(
                      controller: searchTextController,
                      onChanged: (text) {
                       
                      },
                    ),
                    if (filteredSearchTextList.isNotEmpty)
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Scrollbar(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredSearchTextList.length,
                            itemBuilder: (context, index) {
                              final suggestion = filteredSearchTextList[index];
                              return ListTile(
                                title: Text(
                                  suggestion,
                                  style: const TextStyle(color: black),
                                ),
                                onTap: () => _onSuggestionTap(suggestion),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 15),
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
                        BlocProvider.of<AppCubit>(context).setChipSelectedCategory(selectedItem);
                        print('Selected: $selectedItem');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchResultsScreen()),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 15),
                const Text(
                  "Top products",
                  style: TextStyle(
                    fontSize: 20,
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 120,
                  child: BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _showAddReviewBottomSheet(context, state.products[index]),
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: EdgeInsets.all(4),
                                width: 100,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              state.products[index].imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      state.products[index].title,
                                      style: TextStyle(
                                          color: white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      state.products[index].title2,
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: white, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Top services",
                  style: TextStyle(
                    fontSize: 20,
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 120,
                  child: BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.services.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _showAddReviewBottomSheet(context, state.services[index]),
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 100,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              state.services[index].imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      state.services[index].title,
                                      style: TextStyle(
                                          color: white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      state.services[index].title2,
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: white, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Recommended for you",
                  style: TextStyle(
                    fontSize: 20,
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
             SizedBox(
  height: 120,
  child: BlocBuilder<AppCubit, AppState>(
    builder: (context, state) {
      if (state.recommendItems.isEmpty) {
        return Center(
          child: Text(
            "No recommended items available",
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: state.recommendItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showAddReviewBottomSheet(context, state.recommendItems[index]),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 100,
              height: 120,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          state.recommendItems[index].imageUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    state.recommendItems[index].title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    state.recommendItems[index].title2,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ),
)
,

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
