import 'package:dart_dependencies_manager/dart_dependencies_manager.dart';

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

  /// Register a dependency.
  /// Be sure to provide both the type [T] and the [dependency] instance.
  Future<void> registerDependency<T extends Object>(
      Future<T> Function() dependencyBuilder) async {
    DependenciesManager.registerSingletonAsync<T>(dependencyBuilder);
  }
}
