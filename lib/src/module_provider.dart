import 'package:dart_dependencies_manager/dart_dependencies_manager.dart';
import 'package:flutter/widgets.dart';

import 'builders.dart';
import 'module_base.dart';

/// A widget that provide an instance of a module to its descendant child.
/// The module has to be requested by its type like
/// `ModuleProvider<RequestedModule>`.
///
/// The requested module must be injected before the usage of this provider,
/// otherwise an Exception will be thrown.
class ModuleProvider<T extends ModuleBase> extends StatelessWidget {
  /// Creates a [ModuleProvider] widget.
  // ignore: prefer_const_constructors_in_immutables
  ModuleProvider({
    final Key? key,
    required final this.builder,
  }) : super(key: key);

  /// A function that build the child widget and provide the requested
  /// [ModuleBase] to it from its arguments.
  final ModulefulWidgetBuilder<T> builder;

  @override
  Widget build(BuildContext context) =>
      builder(context, DependenciesManager.retrieve<T>());
}
