import 'package:flutter/material.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

class ImageNetworkShimmer extends StatelessWidget {
  final String imageUrl;

  const ImageNetworkShimmer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Shimmer.fromColors(
          baseColor: AppColors.textFieldBackground,
          highlightColor: AppColors.background,
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      },
    );
  }
}
