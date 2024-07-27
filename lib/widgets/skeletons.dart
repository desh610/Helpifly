import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class Skeletons {
  final BuildContext context;
  const Skeletons({required this.context});

  Widget urlSearchResultSkeleton() {
    return Container(
        child: Column(
          children: [
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.37,
                  borderRadius: BorderRadius.circular(8)),
            ),
          ],
        ));
  }
}
