import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seach_bar_test_app/res/res.dart';
import 'package:seach_bar_test_app/widgets/search_list_item.dart';

///окно для поиска подстроки в файле
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();

  ///список для анализа
  List<String> _list = [];

  ///текущий статус
  bool _isSearching;

  ///текст по которому производится поиск
  String _searchText = "";

  Widget appBarTitle = Text(
    AppString.AppBarTitle,
    style: TextStyle(color: AppColors.AppbarTextColor),
  );

  Icon actionIcon = Icon(
    Icons.search,
    color: AppColors.AppbarIconColor,
  );

  _SearchScreenState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  ///подгрузить файл из ресурсов
  Future<List<String>> _loadFile() async {
    List<String> data = [];
    await DefaultAssetBundle.of(context)
        .loadString(AppString.localFilePath)
        .then((q) {
      for (String i in LineSplitter().convert(q)) {
        data.add(i);
      }
    });
    return data;
  }

  ///обновить список
  void initData() async {
    List<String> data = await _loadFile();
    setState(() {
      _list = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    initData();
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: actionIcon,
        onPressed: () {
          setState(() {
            if (this.actionIcon.icon == Icons.search) {
              this.actionIcon = new Icon(
                Icons.close,
                color: AppColors.AppbarIconColor,
              );
              this.appBarTitle = new TextField(
                controller: _searchQuery,
                style: new TextStyle(
                  color: AppColors.AppbarTextColor,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(
                      Icons.search,
                      color: AppColors.AppbarIconColor,
                    ),
                    hintText: AppString.AppBarHintText,
                    hintStyle: new TextStyle(color: AppColors.AppbarHintColor)),
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: AppColors.AppbarIconColor,
      );
      this.appBarTitle = new Text(
        AppString.AppBarTitle,
        style: new TextStyle(color: AppColors.AppbarTextColor),
      );
      _isSearching = false;
      _searchQuery.clear();
    });
  }

  Widget _buildBody() {
    if (_searchText.isEmpty) {
      return ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) => SearchListItem(
          _list[index],
        ),
      );
    } else {
      List<String> _searchList = List();
      _searchList = _list
          .where((element) =>
              element.toLowerCase().startsWith(_searchText.toLowerCase()))
          .toList();
      if (_searchList.length > 0) {
        return ListView.builder(
          itemCount: _searchList.length,
          itemBuilder: (context, index) => SearchListItem(
            _searchList[index],
          ),
        );
      } else
        return Center(
          child: Text(AppString.NotFound),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: key,
      appBar: buildBar(context),
      body: _buildBody(),
    );
  }
}

