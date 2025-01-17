import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noob/src/tools/constants.dart';
import 'package:noob/src/tools/tools.dart';

///
/// A [Widget] showing the pointer positions ontop of its [child].
///
class PointerIndicator extends StatelessWidget {
  const PointerIndicator({
    Key? key,
    this.enabled = true,
    this.minIndicatorSize = 10.0,
    this.normalIndicatorSize = 20.0,
    this.indicatorColor = const Color.fromRGBO(0, 0, 255, 0.2),
    this.child,
  }) : super(key: key);

  ///
  /// Set to `false` to disable the indicators.
  ///
  final bool enabled;

  ///
  /// Size of indicator at pressure `0.0`
  ///
  /// [normalIndicatorSize]
  final double minIndicatorSize;

  ///
  /// Size of indicator at pressure `1.0`
  ///
  /// The actual indicator size is computed as: `minIndicatorSize + (normalIndicatorSize - minIndicatorSize) * pressure`
  ///
  final double normalIndicatorSize;

  ///
  /// Color of the indicator.
  ///
  final Color indicatorColor;

  ///
  /// Child `Widget`.
  ///
  final Widget? child;

  @override
  Widget build(BuildContext context) => Stack(children: [
        if (child != null) child!,
        if (enabled)
          Positioned.fill(
            child: Consumer(
              key: const ValueKey('PositionIndicator'),
              builder: (context, watch, _) {
                final pointers = watch(lastPointerEventProvider);
                final pos = watch(globalPositionProvider(context))?.topLeft;
                return pos == null
                    ? kEmpty
                    : IgnorePointer(
                        child: Stack(
                          children: pointers.values.map((_) {
                            final size = minIndicatorSize +
                                (normalIndicatorSize - minIndicatorSize) *
                                    _.pressure;
                            return Positioned(
                              left: _.position.dx - size / 2 - pos.dx,
                              top: _.position.dy - size / 2 - pos.dy,
                              child: Container(
                                width: size,
                                height: size,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: indicatorColor,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
              },
            ),
          ),
      ]);
}
