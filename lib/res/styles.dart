import 'package:flutter/material.dart';
import 'package:seach_bar_test_app/res/res.dart';

class AppStyles {
  static final searchInputStyle = TextStyle(
    color: AppColors.AppbarTextColor,
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );
  static final searchHintStyle = TextStyle(
    color: AppColors.AppbarHintColor,
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );

  static final notFoundLabel = TextStyle(
    color: AppColors.notFoundLabelColor,
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );
}
