#  Swipe Detector
## Author: [woodjobber](https://github.com/woodjobber)

A package to detect your swipe directions and provides you with callbacks to handle them.

## Usage

```dart
SwipeDetector(
  onSwipe: (direction, offset) {
    print(direction);
  },
  onSwipeUp: (offset) {
    print('up');
  },
  onSwipeDown: (offset) {
    print('down');
  },
  onSwipeLeft: (offset) {
    print('left');
  },
  onSwipeRight: (offset) {
    print('right');
  },
  child: const Container(
    padding: EdgeInsets.all(16),
    child: Text(
      'Swipe me!',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
```