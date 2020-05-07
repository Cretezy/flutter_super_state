import 'package:flutter/widgets.dart';
import 'package:flutter_super_state/flutter_super_state.dart';

typedef StoreBuilderBuilder = Widget Function(
  BuildContext context,
  Store store,
);
typedef StoreBuilderChildBuilder = Widget Function(
  BuildContext context,
  Store store,
  Widget child,
);

/// Get the store inside the Flutter widget tree.
///
/// It is recommended to use [ModuleBuilder] as this will update whenever any of
/// the store's module is updated.
///
/// Example:
/// ```dart
/// Container(
///   child: StoreBuilder(
///     builder: (context, store) {
///       return Text(store.getModule<CounterModule>().counter.toString());
///     },
///   ),
/// )
/// ```
class StoreBuilder extends StatelessWidget {
  /// Store builder.
  final StoreBuilderBuilder builder;

  /// Store child build, passed [child] as third argument.
  /// Takes precedence over [builder].
  final StoreBuilderChildBuilder childBuilder;

  /// Child to be passed to [childBuilder].
  final Widget child;

  const StoreBuilder({
    Key key,
    this.builder,
    this.childBuilder,
    this.child,
  })  : assert(
          childBuilder != null || builder != null,
          "builder or childBuilder must be set",
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.store(context);

    return StreamBuilder(
      stream: store.onChange,
      builder: (context, _) {
        if (childBuilder != null) {
          return childBuilder(context, store, child);
        } else {
          return builder(context, store);
        }
      },
    );
  }
}
