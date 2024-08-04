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
  Widget homeScreenLoaders() {
    return Container(
        child: Row(
          children: [
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                  width: 100,
                  height: 120,
                  borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(width: 12),
             SkeletonAvatar(
              style: SkeletonAvatarStyle(
                  width: 100,
                  height: 120,
                  borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(width: 12),
             SkeletonAvatar(
              style: SkeletonAvatarStyle(
                  width: 100,
                  height: 120,
                  borderRadius: BorderRadius.circular(8)),
            ),
             SizedBox(width: 12),
             SkeletonAvatar(
              style: SkeletonAvatarStyle(
                  width: 100,
                  height: 120,
                  borderRadius: BorderRadius.circular(8)),
            ),
          ],
        ));
  }
}
