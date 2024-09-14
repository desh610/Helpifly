import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/models/request_model.dart';

import '../bloc/app_bloc/app_cubit.dart';

class CompletedListScreen extends StatelessWidget {
  const CompletedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        List<RequestModel> filteredItems = state.requests
            .where((e) => (e.status == 'completed' && e.requestedBy == state.userInfo.uid))
            .toList();

        if (filteredItems.isNotEmpty) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              RequestModel item = filteredItems[index];
              return Container(
                padding: EdgeInsets.only(left: 12),
                margin: EdgeInsets.all(10),
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
                            item.imageUrl,
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
                          style: TextStyle(color: white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
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
    );
  }
}
