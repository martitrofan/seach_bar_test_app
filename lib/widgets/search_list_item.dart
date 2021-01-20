import 'package:flutter/material.dart';

class SearchListItem extends StatelessWidget {
  final String name;

  SearchListItem(this.name);

  @override
  Widget build(BuildContext context) {
    return new ListTile(title: new Text(this.name));
  }
}
