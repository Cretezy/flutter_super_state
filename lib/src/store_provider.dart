import 'package:flutter/widgets.dart';
import 'package:flutter_super_state/src/store.dart';

/// Provide the store to all of the child's widget tree.
///
/// Example:
/// ```dart
/// runApp(StoreProvider(
///   store: store,
///   child: MyApp(),
/// ));
/// ```
class StoreProvider extends InheritedWidget {
  final Store _store;

  const StoreProvider({
    Key key,
    @required Widget child,
    @required Store store,
  })  : assert(child != null, "Child of StoreProvider must be set"),
        assert(store != null, "Store for StoreProvider must be set"),
        _store = store,
        super(key: key, child: child);

  static StoreProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StoreProvider>();
  }

  /// Get the store. Must be a child of [StoreProvider].
  ///
  /// Example:
  /// ```dart
  /// final store = StoreProvider.store(context);
  /// ```
  static Store store(BuildContext context) {
    return of(context)._store;
  }

  @override
  bool updateShouldNotify(StoreProvider old) {
    return old._store != _store;
  }
}
