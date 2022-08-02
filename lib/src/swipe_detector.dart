import 'package:flutter/material.dart';
import 'package:swipe_detector/src/swipe_direction.dart';

class SwipeDetector extends StatefulWidget {
  const SwipeDetector({
    Key? key,
    this.behavior,
    this.onSwipe,
    this.onSwipeUp,
    this.onSwipeDown,
    this.onSwipeLeft,
    this.onSwipeRight,
    required this.child,
  }) : super(key: key);

  /// How this gesture detector should behave during hit testing.
  ///
  /// [HitTestBehavior.opaque] if child is null.
  final HitTestBehavior? behavior;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// Called when the user has swiped in a particular direction.
  ///
  /// - The [direction] parameter is the [SwipeDirection] of the swipe.
  /// - The [offset] parameter is the offset of the swipe in the [direction].
  final void Function(SwipeDirection direction, Offset offset)? onSwipe;

  /// Called when the user has swiped upwards.
  ///
  /// - The [offset] parameter is the offset of the swipe since it started.
  final void Function(Offset offset)? onSwipeUp;

  /// Called when the user has swiped downwards.
  ///
  /// - The [offset] parameter is the offset of the swipe since it started.
  final void Function(Offset offset)? onSwipeDown;

  /// Called when the user has swiped to the left.
  ///
  /// - The [offset] parameter is the offset of the swipe since it started.
  final void Function(Offset offset)? onSwipeLeft;

  /// Called when the user has swiped to the right.
  ///
  /// - The [offset] parameter is the offset of the swipe since it started.
  final void Function(Offset offset)? onSwipeRight;

  @override
  _SwipeDetectorState createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<SwipeDetector> {
  late Offset _startHorizontalDragPosition;
  late Offset _updateHorizontalDragPosition;

  late Offset _startVerticalDragPosition;
  late Offset _updateVerticalDragPosition;
  bool dragEnd = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior ?? HitTestBehavior.opaque,
      onVerticalDragStart: (details) {
        _startVerticalDragPosition = details.localPosition;
      },
      onVerticalDragUpdate: (details) {
        if (!dragEnd) {
          return;
        }
        _updateVerticalDragPosition = details.localPosition;
        SwipeDirection? direction = getVerticalDirection();
        if (direction == null) {
          return;
        }
        dragEnd = false;
        Offset offset = getVerticalDragOffset();
        offset = Offset(offset.dx.abs(), offset.dy.abs());
        if (direction == SwipeDirection.up) {
          widget.onSwipeUp?.call(offset);
        } else {
          widget.onSwipeDown?.call(offset);
        }
        widget.onSwipe?.call(direction, offset);
      },
      onVerticalDragEnd: (endDetails) {
        dragEnd = true;
      },
      onVerticalDragCancel: () {
        dragEnd = true;
      },
      onHorizontalDragStart: (details) {
        _startHorizontalDragPosition = details.localPosition;
      },
      onHorizontalDragUpdate: (details) {
        if (!dragEnd) {
          return;
        }
        _updateHorizontalDragPosition = details.localPosition;
        SwipeDirection? direction = getHorizontalDirection();
        if (direction == null) {
          return;
        }
        dragEnd = false;
        Offset offset = getHorizontalDragOffset();
        offset = Offset(offset.dx.abs(), offset.dy.abs());
        if (direction == SwipeDirection.right) {
          widget.onSwipeRight?.call(offset);
        } else {
          widget.onSwipeLeft?.call(offset);
        }
        widget.onSwipe?.call(direction, offset);
      },
      onHorizontalDragEnd: (endDetails) {
        dragEnd = true;
      },
      onHorizontalDragCancel: () {
        dragEnd = true;
      },
      child: widget.child,
    );
  }

  Offset getHorizontalDragOffset() {
    double dx =
        _updateHorizontalDragPosition.dx - _startHorizontalDragPosition.dx;
    double dy =
        _updateHorizontalDragPosition.dy - _startHorizontalDragPosition.dy;
    return Offset(dx, dy);
  }

  Offset getVerticalDragOffset() {
    double dx = _updateVerticalDragPosition.dx - _startVerticalDragPosition.dx;
    double dy = _updateVerticalDragPosition.dy - _startVerticalDragPosition.dy;
    return Offset(dx, dy);
  }

  SwipeDirection? getHorizontalDirection() {
    Offset offset = getHorizontalDragOffset();
    if (offset.dx.abs() < 1) {
      return null;
    }
    if (offset.dx < 0) {
      return SwipeDirection.left;
    } else {
      return SwipeDirection.right;
    }
  }

  SwipeDirection? getVerticalDirection() {
    Offset offset = getVerticalDragOffset();
    if (offset.dy.abs() < 1) {
      return null;
    }
    if (offset.dy < 0) {
      return SwipeDirection.up;
    } else {
      return SwipeDirection.down;
    }
  }
}
