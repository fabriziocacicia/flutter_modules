import 'package:dart_dependencies_manager/dart_dependencies_manager.dart';
import 'package:flutter/widgets.dart';

import 'builders.dart';
import 'module_base.dart';
import 'module_provider.dart';

/// A widget that injects a [ModuleBase] in the widget tree.
/// It is able to provide the module it injects directly to its child widget.
class ModuleInjector<T extends ModuleBase> extends StatelessWidget {
  /// Constructs a [ModuleInjector] widget.
  /// The [moduleBuilder] is a function that returns an instance of the
  /// [ModuleBase] that has to be injected.
  ModuleInjector({
    final Key? key,
    required final this.moduleBuilder,
    required final this.moduleFoundBuilder,
    required final this.moduleLoadingBuilder,
    required final this.moduleNotFoundBuilder,
  }) : super(key: key) {
    _registerModule(moduleBuilder());
  }

  /// Builds the [ModuleBase] that will be injected in the widget tree.
  final ModuleBuilder<T> moduleBuilder;

  /// The builder where the child [Widget] is defined.
  /// This method should not have side effects since it could be called multiple
  /// times as it is called inside the [build] method.
  final ModulefulWidgetBuilder moduleFoundBuilder;

  final WidgetBuilder moduleLoadingBuilder;

  final WidgetBuilder moduleNotFoundBuilder;

  @override
  Widget build(BuildContext context) => ModuleProvider<T>(
        moduleFoundBuilder: moduleFoundBuilder,
        moduleLoadingBuilder: moduleLoadingBuilder,
        moduleNotFoundBuilder: moduleNotFoundBuilder,
      );

  void _registerModule(final T module) =>
      DependenciesManager.register(module);
}
