import 'package:flutter/material.dart';

import '/src/swipe_direction.dart';

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
  final void Function(SwipeDirection direction)? onSwipe;

  /// Called when the user has swiped upwards.
  ///
  final VoidCallback? onSwipeUp;

  /// Called when the user has swiped downwards.
  ///
  final VoidCallback? onSwipeDown;

  /// Called when the user has swiped to the left.
  ///
  final VoidCallback? onSwipeLeft;

  /// Called when the user has swiped to the right.
  ///
  final VoidCallback? onSwipeRight;

  @override
  _SwipeDetectorState createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<SwipeDetector> {
  late Offset _startHorizontalDragPosition;
  late Offset _updateHorizontalDragPosition;

  late Offset _startVerticalDragPosition;
  late Offset _updateVerticalDragPosition;
  bool alreadyDragEnd = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior ?? HitTestBehavior.opaque,
      onVerticalDragStart: (details) {
        _startVerticalDragPosition = details.localPosition;
      },
      onVerticalDragUpdate: (details) {
        if (!alreadyDragEnd) {
          return;
        }
        _updateVerticalDragPosition = details.localPosition;
        SwipeDirection? direction = getVerticalDirection();
        if (direction == null) {
          return;
        }
        alreadyDragEnd = false;
        if (direction == SwipeDirection.up) {
          widget.onSwipeUp?.call();
        } else {
          widget.onSwipeDown?.call();
        }
        widget.onSwipe?.call(direction);
      },
      onVerticalDragEnd: (endDetails) {
        alreadyDragEnd = true;
      },
      onVerticalDragCancel: () {
        alreadyDragEnd = true;
      },
      onHorizontalDragStart: (details) {
        _startHorizontalDragPosition = details.localPosition;
      },
      onHorizontalDragUpdate: (details) {
        if (!alreadyDragEnd) {
          return;
        }
        _updateHorizontalDragPosition = details.localPosition;
        SwipeDirection? direction = getHorizontalDirection();
        if (direction == null) {
          return;
        }
        alreadyDragEnd = false;
        Offset offset = getHorizontalDragOffset();
        offset = Offset(offset.dx.abs(), offset.dy.abs());
        if (direction == SwipeDirection.right) {
          widget.onSwipeRight?.call();
        } else {
          widget.onSwipeLeft?.call();
        }
        widget.onSwipe?.call(direction);
      },
      onHorizontalDragEnd: (endDetails) {
        alreadyDragEnd = true;
      },
      onHorizontalDragCancel: () {
        alreadyDragEnd = true;
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
