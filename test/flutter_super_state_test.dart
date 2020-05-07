import 'package:flutter_super_state/flutter_super_state.dart';
import 'package:flutter_test/flutter_test.dart';

class CounterModule extends StoreModule<CounterModule> {
  int get counter => _counter;

  var _counter = 0;

  CounterModule(Store store) : super(store);

  void increment() {
    setState(() {
      _counter++;
    });
  }

  void decrement() {
    setState(() {
      _counter--;
    });
  }

  Future<void> incrementAsync() async {
    await Future.delayed(Duration(milliseconds: 10));

    setState(() {
      _counter++;
    });
  }

  Future<void> decrementAsync() async {
    await Future.delayed(Duration(milliseconds: 10));

    setState(() {
      _counter--;
    });
  }
}

void main() {
  test('Creates store correctly', () {
    final store = Store();
    CounterModule(store);

    var storeUpdated = false;
    store.onChange.listen((event) {
      storeUpdated = true;
    });

    var moduleUpdated = false;
    store.getModule<CounterModule>().onChange.listen((event) {
      moduleUpdated = true;
    });

    store.getModule<CounterModule>().increment();

    expect(store.getModule<CounterModule>().counter, 1);

    expect(moduleUpdated, true);
    expect(storeUpdated, true);
  });
}
