import 'package:dart_dependencies_manager/dart_dependencies_manager.dart';

import 'exceptions.dart';

/// The base class for a module.
abstract class ModuleBase {
  /// Default constructor.
  /// It automatically calls [registerDependencies] so that the sub-classes
  /// don't have to.
  ModuleBase() {
    registerDependencies();
  }

  /// Where all the dependencies have to be registered.
  /// To register a dependency call the method [registerDependency]
  /// inside this method.
  void registerDependencies();

  /// Finds a dependency of type [T] from the already registered ones and
  /// returns it.
  T getDependency<T extends Object>() => DependenciesManager.retrieve<T>();

  /// Solves a requested dependency awaiting until it is ready.
  /// This should be called to get the requested dependency when it's needed
  /// in order to create and register another dependencies.
  Future<T> solveDependency<T extends Object>() =>
      DependenciesManager.retrieveAsync<T>();

  /// Register a dependency.
  /// Be sure to provide both the type [T] and the [dependency] instance.
  Future<void> registerDependency<T extends Object>(
      Future<T> Function() dependencyBuilder) async {
    DependenciesManager.registerAsync<T>(dependencyBuilder);
  }

  /// This method completes when all the dependencies registered inside the
  /// module are resolved.
  /// Call it and await its Future completes, then you are ready to use it.
  Future<ModuleBase> ready() async {
    try {
      await DependenciesManager.resolve();
      return this;
    } catch (_) {
      throw ModuleNotReadyException();
    }
  }
}
