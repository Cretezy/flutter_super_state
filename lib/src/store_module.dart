import 'dart:async';

import 'package:flutter_super_state/src/store.dart';

abstract class StoreModule<T extends StoreModule<T>> {
  /// Parent store of the module.
  final Store store;

  final _onChangeController = StreamController<void>.broadcast(sync: true);

  /// Called after [setState] to update the store's `onChange` stream.
  ModuleUpdatedCallback _moduleUpdated;

  /// Stream of updates after `setState`. The value of the stream can be discarded (will always be `null`)
  Stream get onChange => _onChangeController.stream;

  /// Create a store module.
  ///
  /// Must pass the parent store.
  ///
  /// This will automatically register the module in the store.
  StoreModule(this.store) : assert(store != null, "Store must not be null") {
    _moduleUpdated = store.registerModule<T>(this);
  }

  /// Call to update all dependencies after the the update is completed.
  ///
  /// All updates to the module should be wrapped inside.
  /// If this isn't done, the module will not be properly updated.
  ///
  /// Example:
  /// ```dart
  /// setState(() {
  ///   counter++;
  /// });
  /// ```
  void setState(void Function() fn) {
    preSetState();
    fn();
    _onChangeController.add(null);
    postSetState();
    _moduleUpdated();
  }

  /// Can be overridden, and is called before setState updates the state.
  void preSetState() {}

  /// Can be overridden, and is called after setState updated the state.
  ///
  /// This is useful to persist state to disk.
  void postSetState() {}

  /// Disposes of the module. Automatically done if called the store's `dispose`.
  void dispose() {
    _onChangeController.close();
  }
}
