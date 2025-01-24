# MultiValueListenableBuilder

A Fork from this [original repo](https://github.com/ufrshubham/multi-value-listenable-builder)

A widget to listen to multiple [ValueListenable](https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html)s in Flutter.

![pub](https://img.shields.io/pub/v/multi_value_listenable_builder?logo=multivaluelistenablebuilder)

## Usage

- Add the multi_value_listenable_builder as a dependency in your project with url as follows:

```yaml
dependencies:
  multi_value_listenable_builder:
    git:
      url: https://github.com/prcryx/multi-value-listenable-builder.git
      ref: main # branch name
```

- Import `package:multi_value_listenable_builder/multi_value_listenable_builder.dart` in required files.

- Use `MultiValueListenableBuilder` just like any other widget.

```dart
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

MultiValueListenableBuilder(
    // Add all ValueListenables here.
    valueListenables: [
        listenable0,
        listenable1,
        listenable2,
        .
        .
        listenableN
    ],
    builder: (context, values, child) {
        // Get the updated value of each listenable
        // in values list.
        return YourWidget(
            values.elementAt(0),
            values.elementAt(1),
            values.elementAt(2),
            .
            .
            values.elementAt(N),
            child: child // Optional child.
        );
    },
    child: YourOptionalChildWidget(),
)
```

A detailed and working example can be found [here](https://github.com/ufrshubham/multi-value-listenable-builder/tree/main/example/).
