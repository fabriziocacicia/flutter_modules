import 'package:flutter/widgets.dart';

import 'module_base.dart';

/// Signature of a function that build a [Widget] and provide to it an
/// instance of a [ModuleBase].
typedef ModulefulWidgetBuilder<S extends ModuleBase> = Widget Function(
    BuildContext context, S module);

/// Signature of a function that build a [ModuleBase] object.
typedef ModuleBuilder<T extends ModuleBase> = T Function();
