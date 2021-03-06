import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pintersest_clone/app_route.dart';
import 'package:pintersest_clone/values/app_colors.dart';
import 'package:pintersest_clone/view/common/base_text_field.dart';
import 'package:pintersest_clone/view/main/select_board_from_local/select_board_from_local_widget.dart';

class CreatePinArguments {
  CreatePinArguments(this.image);

  final File image;
}

class CreatePinWidget extends StatefulWidget {
  @override
  _CreatePinWidgetState createState() => _CreatePinWidgetState();
}

class _CreatePinWidgetState extends State<CreatePinWidget> {
  String _linkUrl;
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as CreatePinArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ピンを作成', style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.black),
        brightness: Brightness.light,
        elevation: 0,
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            child: FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoute.selectBoardFromLocal,
                    arguments: SelectBoardFromLocalArguments(
                        image: args.image,
                        title: _titleTextController.text,
                        description: _descriptionTextController.text,
                        linkUrl: _linkUrl));
              },
              color: AppColors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('次へ', style: TextStyle(color: AppColors.white)),
            ),
          )
        ],
      ),
      body: _buildScreen(context),
    );
  }

  Widget _buildScreen(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as CreatePinArguments;
    return Container(
      padding: const EdgeInsets.all(16),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Image.file(args.image),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 16),
          ),
          SliverToBoxAdapter(
            child: BaseTextField(
                title: 'タイトル',
                hintText: 'ピンのタイトルを入力',
                textEditingController: _titleTextController),
          ),
          SliverToBoxAdapter(
            child: BaseTextField(
                title: '説明文',
                hintText: 'このピンの説明文を入力してください',
                textEditingController: _descriptionTextController),
          ),
          SliverToBoxAdapter(
            child: _buildAddLinkButton(),
          )
        ],
      ),
    );
  }

  Widget _buildAddLinkButton() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text('リンク先ウェブサイト'),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: RaisedButton(
              elevation: 0,
              child: const Text('追加'),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
