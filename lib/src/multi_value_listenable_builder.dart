import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef MultiValueListenableTransformer<M> = M Function(List<dynamic> values);

typedef MultiValueWidgetBuilder = Widget Function(
  BuildContext context,
  List<dynamic> values,
  Widget? child,
);

typedef MultiValueTransfromedWidgetBuilder<M> = Widget Function(
  BuildContext context,
  M values,
  Widget? child,
);

/// This widget listens to multiple [ValueListenable]s and
/// calls given builder function if any one of them changes.
class MultiValueListenableBuilder<T> extends StatefulWidget {
  /// List of [ValueListenable]s to listen to.

  final List<ValueListenable> valueListenables;

  /// The builder function to be called when value of any of the [ValueListenable] changes and [transformer] is null
  /// The order of values list will be same as [valueListenables] list. if [transformer] is null then it will be in effect instead of [builderWhenTransformed].

  final MultiValueWidgetBuilder? builder;

  /// An transformer which listens to multiple [ValueListenable]s and transforms their notification to a single resultant one.
  final MultiValueListenableTransformer<T>? transformer;

  /// A resultant [ValueNotifier] that subscribes to notification triggered by [transformer].
  /// if [transformer] is null then it has no effect.

  final ValueNotifier<T>? transformedListenable;

  /// The builder function to be called when value of any of the [ValueListenable] changes with [transformer] set.
  /// if [transformer] is null then it has no effect.

  final MultiValueTransfromedWidgetBuilder<T>? builderWhenTransformed;

  /// An optional child widget which will be avaliable as child parameter in [builder].

  final Widget? child;

  // The const constructor.
  const MultiValueListenableBuilder({
    Key? key,
    required this.valueListenables,
    this.builder,
    this.transformer,
    this.transformedListenable,
    this.builderWhenTransformed,
    this.child,
  })  : assert(valueListenables.length != 0),
        super(key: key);

  @override
  State<MultiValueListenableBuilder<T>> createState() =>
      _MultiValueListenableBuilderState<T>();
}

class _MultiValueListenableBuilderState<T>
    extends State<MultiValueListenableBuilder<T>> {
  late Listenable _listenables;
  T? _transformedValue;
  List<dynamic> _values = [];
  @override
  void initState() {
    super.initState();
    _listenables = Listenable.merge(widget.valueListenables)
      ..addListener(_onValuesChanged);

    _updateValues();
  }

  @override
  void dispose() {
    super.dispose();
    _listenables.removeListener(_onValuesChanged);
  }

  void _onValuesChanged() {
    _updateValues();
    if (widget.transformer != null) {
      _updateTransformedListenable();
    }
  }

  void _updateValues() {
    _values = widget.valueListenables.map((n) => n.value).toList();
    if (widget.transformer != null) {
      _transformedValue = widget.transformer?.call(_values) as T;
    }
  }

  void _updateTransformedListenable() {
    if (widget.transformedListenable != null && widget.transformer != null) {
      widget.transformedListenable!.value = _transformedValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _listenables,
      builder: (context, child) {
        if (widget.transformer != null) {
          return widget.builderWhenTransformed!(
            context,
            _transformedValue!,
            child,
          );
        }
        return widget.builder!(
            context, List<dynamic>.unmodifiable(_values), child);
      },
      child: widget.child,
    );
  }
}
