import 'package:dart_dependencies_manager/dart_dependencies_manager.dart';
import 'package:flutter/material.dart';
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
    required final this.moduleFoundBuilder,
    required final this.moduleLoadingBuilder,
    required final this.moduleNotFoundBuilder,
  }) : super(key: key);

  /// A function that build the child widget and provide the requested
  /// [ModuleBase] to it from its arguments.
  final ModulefulWidgetBuilder<T> moduleFoundBuilder;

  final WidgetBuilder moduleLoadingBuilder;

  final WidgetBuilder moduleNotFoundBuilder;

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
        future: DependenciesManager.retrieveAsync<T>(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return moduleLoadingBuilder(context);
          } else {
            if (snapshot.hasData) {
              return moduleFoundBuilder(context, snapshot.data!);
            } else {
              return moduleNotFoundBuilder(context);
            }
          }
        },
      );
}
