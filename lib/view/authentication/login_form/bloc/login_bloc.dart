import 'package:bloc/bloc.dart';
import 'package:pintersest_clone/data/auth_repository.dart';

import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authRepository);

  final AuthRepository _authRepository;

  @override
  LoginState get initialState => InitialState();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is Login) {
      yield LoadingState();
      try {
        await _authRepository.signIn(event.loginRequestModel);
        yield SuccessState();
      } on Exception catch (e) {
        yield ErrorState(e);
      }
    }
  }
}
