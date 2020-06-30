import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:pintersest_clone/api/auth_api.dart';
import 'package:pintersest_clone/api/board_api.dart';
import 'package:pintersest_clone/api/image_api.dart';
import 'package:pintersest_clone/api/pins_api.dart';
import 'package:pintersest_clone/api/users_api.dart';
import 'package:pintersest_clone/app_route.dart';
import 'package:pintersest_clone/data/auth_repository.dart';
import 'package:pintersest_clone/data/pins_repository.dart';
import 'package:pintersest_clone/data/users_repository.dart';
import 'package:pintersest_clone/util/authentication_preferences.dart';
import 'package:pintersest_clone/view/authentication//login_top_widget/login_top_widget.dart';
import 'package:pintersest_clone/view/authentication//login_widget/login_widget.dart';
import 'package:pintersest_clone/view/authentication//sign_up_widget/create_account_widget.dart';
import 'package:pintersest_clone/view/authentication/login_form_widget/login_form_widget.dart';
import 'package:pintersest_clone/view/authentication/sign_up_form_widget/sign_up_form_widget.dart';
import 'package:pintersest_clone/view/main/board_detail_widget/board_detail_widget.dart';
import 'package:pintersest_clone/view/main/crawling_image/crawling_image_widget.dart';
import 'package:pintersest_clone/view/main/create_board_widget/create_board_widget.dart';
import 'package:pintersest_clone/view/main/create_pin_widget/create_pin_widget.dart';
import 'package:pintersest_clone/view/main/edit_crawling_image_widget/edit_crawling_image_widget.dart';
import 'package:pintersest_clone/view/main/input_url_widget/input_url_widget.dart';
import 'package:pintersest_clone/view/main/main_navigation_page.dart';
import 'package:pintersest_clone/view/main/pin_detail_widget/pin_detail_widget.dart';
import 'package:pintersest_clone/view/main/select_board_from_local_widget/select_board_from_local_widget.dart';
import 'package:pintersest_clone/view/main/select_board_from_url_widget/select_board_from_url_widget.dart';
import 'package:pintersest_clone/view/main/user_detail_widget/user_detail_widget.dart';

import 'api/api_client.dart';
import 'data/boards_repository.dart';
import 'data/image_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authenticationPreferences = AuthenticationPreferences();
  final token = await authenticationPreferences.getAccessToken();
  final initialRoute =
      token?.isNotEmpty ?? false ? AppRoute.home : AppRoute.loginTop;
  runApp(Pinterest(initialRoute));
}

class Pinterest extends StatelessWidget {
  const Pinterest(this.initialRoute);

  final String initialRoute;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authenticationPreferences = AuthenticationPreferences();
    final apiClient = ApiClient(Client(), authenticationPreferences);
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ImageRepository>(
            create: (_) => ImageRepository(DefaultImageApi(apiClient)),
          ),
          RepositoryProvider<PinsRepository>(
            create: (_) => PinsRepository(DefaultPinsApi(apiClient)),
          ),
          RepositoryProvider<BoardsRepository>(
            create: (_) => BoardsRepository(DefaultBoardsApi(apiClient)),
          ),
          RepositoryProvider<UsersRepository>(
            create: (_) => UsersRepository(DefaultUsersApi(apiClient)),
          ),
          RepositoryProvider<AuthRepository>(
            create: (_) => AuthRepository(
                DefaultAuthApi(apiClient), authenticationPreferences),
          ),
        ],
        child: MaterialApp(
          title: 'Pinterest',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: initialRoute,
          routes: _configureRoutes(context),
        ));
  }

  Map<String, WidgetBuilder> _configureRoutes(BuildContext context) {
    return {
      AppRoute.home: (context) => MainNavigationPage(),
      AppRoute.pinDetail: (context) => PinDetailWidget(),
      AppRoute.userDetail: (context) => UserDetailWidget(),
      AppRoute.inputUrl: (context) => InputUrlWidget(),
      AppRoute.crawlingImage: (context) => CrawlingImageWidget(),
      AppRoute.loginTop: (context) => LoginTopWidget(),
      AppRoute.createAccount: (context) => SignUpWidget(),
      AppRoute.login: (context) => LoginWidget(),
      AppRoute.createPin: (context) => CreatePinWidget(),
      AppRoute.createBoard: (context) => CreateBoardWidget(),
      AppRoute.editCrawlingImage: (context) => EditCrawlingImageWidget(),
      AppRoute.selectBoardFromLocal: (context) => SelectBoardFromLocalWidget(),
      AppRoute.selectBoardFromUrl: (context) => SelectBoardFromUrlWidget(),
      AppRoute.signupForm: (context) => SignUpFormWidget(),
      AppRoute.loginForm: (context) => LoginFormWidget(),
      AppRoute.boardDetail: (context) => BoardDetailWidget(),
    };
  }
}
