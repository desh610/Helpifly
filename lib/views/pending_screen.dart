import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/models/request_model.dart';

class PendingListScreen extends StatelessWidget {
  const PendingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        // Filter the requests
        List<RequestModel> filteredItems = state.requests
            .where((e) =>
                (e.status == 'pending' && e.requestedBy == state.userInfo.uid))
            .toList();

        if (filteredItems.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            physics: const BouncingScrollPhysics(),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              RequestModel item = filteredItems[index];
              return Container(
                padding: const EdgeInsets.only(left: 12),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                          image: NetworkImage(item.imageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            item.title2,
                            style: const TextStyle(
                              color: white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: grayColor.withOpacity(0.2)
                            ),
                            child: const Text(
                              "In Review",
                              style: TextStyle(
                                color: grayColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
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
