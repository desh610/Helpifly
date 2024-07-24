import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/models/user_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? firstName;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoJson = prefs.getString('user_info');
    if (userInfoJson != null) {
      try {
        Map<String, dynamic> userMap = jsonDecode(userInfoJson);
        UserInfoModel userInfo = UserInfoModel.fromJson(userMap);
        setState(() {
          firstName = userInfo.firstName;
        });
      } catch (e) {
        // Handle JSON decode error
        setState(() {
          firstName = 'User';
        });
        print('Error decoding user info: $e');
      }
    } else {
      // Fallback to a default name if SharedPreferences is null
      setState(() {
        firstName = 'User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text(
                    "Welcome ${firstName ?? 'User'},",
                    style: const TextStyle(
                      color: white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.6,
                    ),
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
              CustomSearchBar(),
              const SizedBox(height: 15),
              BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  return ChipContainer(
                    items: state.categories.take(5).toList(),
                    initialSelectedItem: "Institutes",
                    selectedColor: secondaryColor,
                    unselectedColor: cardColor,
                    selectedTextColor: black,
                    unselectedTextColor: white,
                    onTap: (selectedItem) {
                      print('Selected: $selectedItem');
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
                        if (state.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.error != null) {
                    return Center(child: Text(state.error!, style: TextStyle(color: white)));
                  }
                        else{
                          return Container(
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
                                          'https://i.pinimg.com/280x280_RS/56/ee/fe/56eefe4d7953d6cd43089ef54766fc2d.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              SizedBox(height: 4),
                              Text(
                                state.products[index].title,
                                style: TextStyle(
                                    color: white, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                state.products[index].title2,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: white, fontSize: 10),
                              ),
                            ],
                          ),
                        );
                        }
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
                        if (state.isLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state.error != null) {
                          return Center(
                              child: Text(state.error!,
                                  style: TextStyle(color: white)));
                        } else {
                          return Container(
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
                                            'https://i.pinimg.com/280x280_RS/56/ee/fe/56eefe4d7953d6cd43089ef54766fc2d.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  state.services[index].title,
                                  style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Telecommunication Service Provider",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: white, fontSize: 10),
                                ),
                              ],
                            ),
                          );
                        }
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Container(
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
                                      'https://i.pinimg.com/280x280_RS/56/ee/fe/56eefe4d7953d6cd43089ef54766fc2d.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Dialog",
                            style: TextStyle(
                                color: white, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Telecommunication Service Provider",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: white, fontSize: 10),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
