import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seach_bar_test_app/res/res.dart';
import 'package:seach_bar_test_app/res/styles.dart';
import 'package:seach_bar_test_app/widgets/search_list_item.dart';

///окно для поиска подстроки в файле
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchQuery = TextEditingController();

  ///текст по которому производится поиск
  String _searchText = "";

  ///список для анализа
  List<String> _list = [];

  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = Text(AppString.AppBarTitle);

  _SearchScreenState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void despose() {
    _searchQuery.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildBody(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
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
      List<String> _searchList;
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
          child: Text(
            AppString.NotFound,
            style: AppStyles.notFoundLabel,
          ),
        );
    }
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          style: AppStyles.searchInputStyle,
          controller: _searchQuery,
          decoration: InputDecoration(
            hintText: AppString.AppBarHintText,
            hintStyle: AppStyles.searchHintStyle,
          ),
        );
      } else {
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle = Text(AppString.AppBarTitle);
        _searchQuery.clear();
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
}
