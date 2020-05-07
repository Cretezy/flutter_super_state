import 'package:flutter/widgets.dart';
import 'package:flutter_super_state/src/store_module.dart';
import 'package:flutter_super_state/src/store_provider.dart';

typedef ModuleBuilderBuilder<T> = Widget Function(
  BuildContext context,
  T module,
);
typedef ModuleBuilderChildBuilder<T> = Widget Function(
  BuildContext context,
  T module,
  Widget child,
);

/// Get the module of type [T] inside the Flutter widget tree.
///
/// The builders will update when the module updates (calls `setState`)
///
/// Example:
/// ```dart
/// Container(
///   child: ModuleBuilder<CounterModule>(
///     builder: (context, counterModule) {
///       return Text(counterModule.counter.toString());
///     },
///   ),
/// )
/// ```
class ModuleBuilder<T extends StoreModule> extends StatelessWidget {
  /// Module builder.
  final ModuleBuilderBuilder<T> builder;

  /// Module child build, passed [child] as third argument.
  /// Takes precedence over [builder].
  final ModuleBuilderChildBuilder<T> childBuilder;

  /// Child to be passed to [childBuilder].
  final Widget child;

  const ModuleBuilder({
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
    final module = StoreProvider.store(context).getModule<T>();

    return StreamBuilder(
      stream: module.onChange,
      builder: (context, _) {
        if (childBuilder != null) {
          return childBuilder(context, module, child);
        } else {
          return builder(context, module);
        }
      },
    );
  }
}
