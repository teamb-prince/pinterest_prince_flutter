import 'package:bloc/bloc.dart';
import 'package:pintersest_clone/data/pins_repository.dart';
import 'package:pintersest_clone/view/main/home_widget/bloc/home_event.dart';
import 'package:pintersest_clone/view/main/home_widget/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PinsRepository _pinsRepository;

  HomeBloc(this._pinsRepository);

  @override
  HomeState get initialState => LoadingState();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadData) {
      print("move");
      yield LoadingState();
      try {
        final pins = await _pinsRepository.getPins();
        print(pins);
        if (pins.length == 0) {
          yield NoDataState();
        } else {
          yield LoadedState(pins);
        }
      } on Exception catch (e) {
        yield ErrorState(e);
      }
    }
  }
}
