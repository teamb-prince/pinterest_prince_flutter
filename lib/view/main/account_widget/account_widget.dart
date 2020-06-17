import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pintersest_clone/app_route.dart';
import 'package:pintersest_clone/data/pins_repository.dart';
import 'package:pintersest_clone/model/pin_model.dart';
import 'package:pintersest_clone/view/main/create_pin_widget/create_pin_widget.dart';
import 'package:pintersest_clone/view/main/home_widget/bloc/home_bloc.dart';
import 'package:pintersest_clone/view/main/home_widget/bloc/home_event.dart';
import 'package:pintersest_clone/view/main/home_widget/bloc/home_state.dart';

class AccountWidget extends StatefulWidget {
  @override
  _AccountWidgetState createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  File _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _searchTextController = TextEditingController();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    _image = File(pickedFile.path);
    Navigator.pushNamed(context, AppRoute.createPin,
        arguments: CreatePinArguments(_image));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) =>
          HomeBloc(context.repository<PinsRepository>())..add(LoadData()),
      child: _buildScreen(context),
    );
  }

  Widget _buildScreen(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            backgroundColor: Colors.white,
            bottom: TabBar(
              indicatorColor: Colors.black87,
              labelColor: Colors.black87,
              labelStyle: const TextStyle(fontSize: 10),
              tabs: <Widget>[
                const Tab(text: 'ボード'),
                const Tab(text: 'ピン'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Container(color: Colors.red),
            _buildScrollView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollView(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, HomeState state) {
      if (state is LoadedState) {
        final List<PinModel> pins = state.pins;
        return Container(
          padding: const EdgeInsets.all(8),
          child: CustomScrollView(slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Column(children: <Widget>[_buildSearchBar()])
              ]),
            ),
            SliverStaggeredGrid.countBuilder(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              itemBuilder: (context, index) => _getChild(context, pins[index]),
              staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
              itemCount: pins.length,
            ),
          ]),
        );
      }
      return Container();
    });
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _searchTextController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                prefixIcon: Icon(
                  Icons.search,
                  size: 24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
                hintText: '自分のピンを探す',
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: getImage,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AppRoute.inputUrl);
            },
          ),
        ],
      ),
    );
  }

  Widget _getChild(BuildContext context, PinModel pin) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  pin.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ));
  }
}
