import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class BootLoadingScreen extends StatelessWidget {
  const BootLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: AppColors.gold),
      ),
    );
  }
}
