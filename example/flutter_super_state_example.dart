import 'package:flutter/material.dart';
import 'package:flutter_super_state/flutter_super_state.dart';

class CounterModule extends StoreModule<CounterModule> {
  int get counter => _counter;

  var _counter = 0;

  CounterModule(Store store) : super(store);

  void increment() {
    setState(() {
      _counter++;
    });
  }
}

void main() {
  final store = Store();
  CounterModule(store);

  runApp(StoreProvider(
    store: store,
    child: ExampleApp(),
  ));
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "flutter_super_state example",
      home: Scaffold(
        appBar: AppBar(
          title: Text("flutter_super_state example"),
        ),
        body: ModuleBuilder<CounterModule>(
          builder: (context, counterModule) => Column(
            children: <Widget>[
              Center(
                child: RaisedButton(
                  child: Text("Increment"),
                  onPressed: () => counterModule.increment(),
                ),
              ),
              Center(
                child: Text("Pressed ${counterModule.counter} times"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
