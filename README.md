# flutter_modules

A library for implementing modularity in Flutter apps.

## The idea

The solution came from a Flutter app developed implementing the _Clean 
Architecture_ in a modular way, but there is no need to use such approach to take 
advantage of this package.

Each feature in the app is considered a module, so for each one of them
there is a _**Module**_.

A _**Module**_ acts as a dependency container.

A _**Module**_ is then injected in the widgets tree and provided to the other 
widgets that need the dependencies it contains.


## Overview

### ModuleBase
A `ModuleBase` is a base class for a feature module.

In the context of a _Clean Architecture_ app, it is defined in the application
layer of a feature.

It is used to register dependencies using the `registerDependencies` method.

It is used retrieve already registered dependencies using the `getDependency` method.

### ModuleInjector
A `ModuleInjector` is a widget that injects a `ModuleBase` in the widgets tree and also immediately provides it to its child widget.

### ModuleProvider
A `ModuleProvider` is a widget that provide an instance of a previously injected `ModuleBase` to its child.


## Usage

Let's see an example of creating a module for a feature called _MyFeature_.

In the _application_ layer of the feature let's create a `MyFeatureModule`.

```dart
import 'package:flutter_modules/flutter_modules.dart';

class MyFeatureModule extends ModuleBase {
  @override
  void registerDependencies() {}
}
```

Inside the `registerDependencies` method we have to register all the dependencies 
needed in the feature.

So, for example, suppose we have a `MyProvider` class and a `MyRepository`class 
that depends on the previous one and that they are dependencies of our `MyFeatureModule`.

We will use the method `registerDependency` inside `registerDependencies` to
register each one of them.

```dart
import 'package:flutter_modules/flutter_modules.dart';

class MyFeatureModule extends ModuleBase {
  @override
  void registerDependencies() {
    registerDependency<MyProvider>(MyProvider());

    registerDependency<MyRepository>(MyRepository(provider: getDependency<MyProvider>()));
  }
}
```

In the case of the registration of the `MyRepository` we used the `getDependency`
method to retrieve the already registered `MyProvider` instance and provide it
to the `MyRepository` constructor.

Under the hood all the dependencies are registered as _**lazy singleton**_, and
they are tracked by type, so you can register only one instance of a specific 
type. If you register an object whose type was already registered, the registration
will be ignored.

Once we define our _module_ we can inject it to the widgets tree to use it. This is done by using the `ModuleInjector`:
```dart
import 'package:flutter_modules/flutter_modules.dart';

 @override
  Widget build(BuildContext context) {
    return ModuleInjector(
            moduleBuilder: () => MyFeatureModule(),
            widgetBuilder: (context, module) {
                final myRepository = module.getDependency<MyRepository>();
            
                return Text(myRepository.get());
            }
   );
  }
```
The `ModuleInjector` injects the `MyFeatureModule` into the widgets tree and immediately provides it.

If the `MyFeatureModule` is needed in another place (but still in a branch of the widgets tree where it was previously injected), we can use the `ModuleProvider` to obtain its instance:
```dart
import 'package:flutter_modules/flutter_modules.dart';

 @override
  Widget build(BuildContext context) {
    return ModuleProvider<MyFeatureModule>(
            builder: (context, module) {
                final myRepository = module.getDependency<MyRepository>();
            
                return Text(myRepository.get());
            }
   );
  }
```