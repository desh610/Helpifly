import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/models/request_model.dart';
import 'package:helpifly/views/completed_list_screen.dart';
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
          automaticallyImplyLeading: false,
          title: const Text('Requests', style: TextStyle(fontSize: 16, color: lightGrayColor),),
          backgroundColor: primaryColor,
          centerTitle: true,
          elevation: 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: white,),
              onPressed: () => _showAddRequestsBottomSheet(context),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: secondaryColor,
            tabs: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Pending", style: TextStyle(color: lightGrayColor),),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Completed", style: TextStyle(color: lightGrayColor),),
              )
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

