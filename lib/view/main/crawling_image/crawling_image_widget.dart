import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pintersest_clone/app_route.dart';
import 'package:pintersest_clone/data/image_repository.dart';
import 'package:pintersest_clone/values/app_colors.dart';
import 'package:pintersest_clone/view/main/edit_crawling_image/edit_crawling_image_widget.dart';

import 'bloc/bloc.dart';

class CrawlingImageArgs {
  CrawlingImageArgs({@required this.url});

  final String url;
}

class CrawlingImageWidget extends StatefulWidget {
  @override
  _CrawlingImageState createState() => _CrawlingImageState();
}

class _CrawlingImageState extends State<CrawlingImageWidget> {
  int _selectedIndex = -1;
  final _footerHeight = 48.0;
  String _selectedUrl = '';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as CrawlingImageArgs;
    return BlocProvider<CrawlingImageBloc>(
      create: (context) =>
          CrawlingImageBloc(context.repository<ImageRepository>())
            ..add(RequestSearch(args.url)),
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          iconTheme: const IconThemeData(
            color: AppColors.black, //change your color here
          ),
          elevation: 0,
          backgroundColor: AppColors.white,
          title: const Text(
            '画像を選択',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: AppColors.black),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocBuilder<CrawlingImageBloc, CrawlingImageState>(
              builder: (context, state) {
            if (state is LoadedState) {
              final imageUrls = state.imageModel.imageUrls;

              return Container(
                child: Column(
                  children: [
                    Expanded(child: _buildGetImage(imageUrls)),
                    _buildFooter(args.url, state.imageModel.title,
                        state.imageModel.description),
                  ],
                ),
              );
            } else if (state is NoImageState) {
              return const Text('No image.');
            } else if (state is ErrorState) {
              return Text(state.exception.toString());
            } else if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InitialState) {
              return const Text('Initial state.');
            }
            return Container();
          }),
        ),
      ),
    );
  }

  Widget _buildGetImage(List<String> imageUrls) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        children: List.generate(imageUrls.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
                _selectedUrl = imageUrls[index];
              });
            },
            child: Stack(
              children: [
                Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                ),
                _selectedIndex == index ? _buildCheckbox() : Container(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCheckbox() {
    return const Positioned(
      top: 4,
      left: 4,
      child: Icon(
        Icons.check_circle,
        color: AppColors.red,
      ),
    );
  }

  Widget _buildFooter(String url, String title, String description) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: _footerHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RaisedButton(
              child: const Text(
                '保存', // TODO Pinのボードへの保存処理はDBが固まってから
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.white),
              ),
              color: AppColors.red,
              onPressed: () {
                if (_selectedIndex != -1) {
                  Navigator.pushNamed(
                    context,
                    AppRoute.editCrawlingImage,
                    arguments: EditCrawlingImageArgs(
                        url: url,
                        imageUrl: _selectedUrl,
                        title: title,
                        description: description),
                  );
                } else {
                  print('show alert'); //TODO 戻った時に、一覧画像を更新する作業
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
