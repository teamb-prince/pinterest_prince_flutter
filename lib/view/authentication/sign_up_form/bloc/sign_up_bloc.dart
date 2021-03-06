import 'package:bloc/bloc.dart';
import 'package:pintersest_clone/api/errors/error.dart';
import 'package:pintersest_clone/data/auth_repository.dart';

import 'bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this._authRepository);

  final AuthRepository _authRepository;

  @override
  SignUpState get initialState => InitialState();

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUp) {
      yield LoadingState();
      try {
        final userModel =
            await _authRepository.signUp(event.signUpRequestModel);

        yield SuccessState(userModel);
      } on ForbiddenServerError catch (e) {
        yield ExistUserState(e);
      } on Exception catch (e) {
        yield ErrorState(e);
      }
    }
  }
}
