import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/models/request_model.dart';
import 'package:helpifly/views/pending_screen.dart';
import 'package:helpifly/widgets/add_request_bottomsheet.dart';

import '../bloc/app_bloc/app_cubit.dart';
import '../bloc/app_bloc/app_state.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

    void _showAddRequestsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      builder: (BuildContext context) {
        return AddRequestBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          title: const Text('Requests', style: TextStyle(fontSize: 16, color: white),),
          backgroundColor: primaryColor,
          centerTitle: true,
          elevation: 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddRequestsBottomSheet(context),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: secondaryColor,
            tabs: [
              Tab(text: 'Pending List'),
              Tab(text: 'Completed List'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PendingListScreen(),
            CompletedListScreen(),
          ],
        ),
      ),
    );
  }
}



class CompletedListScreen extends StatelessWidget {
  const CompletedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Completed List',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
