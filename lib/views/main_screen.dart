import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/views/forum_screen.dart';
import 'package:helpifly/views/home_screen.dart';
import 'package:helpifly/views/profile_screen.dart';
import 'package:helpifly/views/url_results_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<Widget> _screens = [
    const HomeScreen(),
    UrlResultsScreen(),
    ForumScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(BuildContext context, int index) {
    context.read<AppCubit>().setCurrentTabIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return _screens[state.currentTabIndex];
        },
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
            currentIndex: state.currentTabIndex,
            onTap: (index) => _onItemTapped(context, index),
            selectedItemColor: grayColor,
            unselectedItemColor: Colors.grey,
            backgroundColor: inCardColor,
            type: BottomNavigationBarType.fixed,
          );
        },
      ),
    );
  }
}
