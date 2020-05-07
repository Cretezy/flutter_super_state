import 'dart:async';

import 'package:flutter_super_state/src/store_module.dart';

typedef ModuleUpdatedCallback = void Function();

class Store {
  final _onChangeController = StreamController<void>.broadcast(sync: true);

  /// Stream of updates after [StoreModule.setState] in any child module. The value of the stream can be discarded (will always be `null`)
  Stream get onChange => _onChangeController.stream;

  final _modules = Map<String, StoreModule>();

  /// Do not call this manually! It will not update the store's [onChange] when the module is called.
  /// This is automatically called when calling `super` for a [StoreModule]
  ///
  /// Registers module of type [T] to the store.
  ///
  /// Only one module per type is allowed, and [T] must be unique as string.
  ModuleUpdatedCallback registerModule<T extends StoreModule<T>>(
      StoreModule module) {
    if (T == StoreModule) {
      throw new Exception("T is StoreModule. Did you forget to pass in T?");
    }

    final exists = _getModule<T>() != null;

    if (exists) {
      throw new Exception("Module of type $T already registered");
    }

    _modules[T.toString()] = module;

    return () {
      _onChangeController.add(null);
    };
  }

  /// Get the module of type [T] inside the store.
  ///
  /// Will throw an error if the module doesn't exist in the store
  T getModule<T extends StoreModule<T>>() {
    if (T == StoreModule) {
      throw new Exception("T is StoreModule. Did you forget to pass in T?");
    }

    final module = _getModule<T>();

    if (module == null) {
      throw new Exception("Could not find module of type $T");
    }

    return module;
  }

  T _getModule<T>() {
    return _modules[T.toString()] as T;
  }

  /// Dispose of the store, and all of it's modules.
  void dispose() {
    _onChangeController.close();

    _modules.forEach((_, value) {
      value.dispose();
    });
  }
}
