import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final privateIsLoading = BehaviorSubject<bool>.seeded(true);

  Function(bool) get changeIsLoading => privateIsLoading.sink.add;

  Stream<bool> get isLoading => privateIsLoading.stream;

  dispose() {
    privateIsLoading.close();
  }
}
