import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/views/forum_screen.dart';
import 'package:helpifly/views/home_screen.dart';
import 'package:helpifly/views/profile_screen.dart';
import 'package:helpifly/views/requests_screen.dart';
import 'package:helpifly/views/url_results_screen.dart';
import 'package:helpifly/widgets/screen_loading.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    const HomeScreen(),
    UrlResultsScreen(),
    ForumScreen(),
    RequestsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load the items and requests once during initialization
    final appCubit = context.read<AppCubit>();
    appCubit.loadItems();
    appCubit.loadRequests();
  }

  void _onItemTapped(int index) {
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
            items: const [
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
                icon: Icon(Icons.request_page_rounded),
                label: 'Requests',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: state.currentTabIndex,
            onTap: _onItemTapped,
            selectedItemColor: grayColor,  // Use your predefined color
            unselectedItemColor: Colors.grey,
            backgroundColor: inCardColor,
            type: BottomNavigationBarType.fixed,
          );
        },
      ),
    );
  }
}
