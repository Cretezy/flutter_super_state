import 'package:flutter_super_state/flutter_super_state.dart';
import 'package:flutter_test/flutter_test.dart';

class CounterModule extends StoreModule {
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

  var preCalled = false;

  @override
  void preSetState() {
    preCalled = true;
  }

  var postCalled = false;

  @override
  void postSetState() {
    postCalled = true;
  }
}

void main() {
  test('Can increment', () {
    final store = Store();
    CounterModule(store);

    expectLater(store.onChange, emits(null));
    expectLater(store.getModule<CounterModule>().onChange, emits(null));

    store.getModule<CounterModule>().increment();

    expect(store.getModule<CounterModule>().counter, 1);
  });

  test('Can increment async', () async {
    final store = Store();
    CounterModule(store);

    expectLater(store.onChange, emits(null));
    expectLater(store.getModule<CounterModule>().onChange, emits(null));

    await store.getModule<CounterModule>().incrementAsync();

    expect(store.getModule<CounterModule>().counter, 1);
  });

  test('Calls pre/postSetState', () {
    final store = Store();
    final counterModule = CounterModule(store);

    expect(counterModule.preCalled, false);
    expect(counterModule.postCalled, false);

    store.getModule<CounterModule>().increment();

    expect(counterModule.preCalled, true);
    expect(counterModule.postCalled, true);
  });

  test('Throws when double registered', () {
    final store = Store();
    CounterModule(store);

    expect(() => CounterModule(store), throwsException);
  });

  test('Throws when getting module that is not registered', () {
    final store = Store();

    expect(() => store.getModule<CounterModule>(), throwsException);
  });
}
