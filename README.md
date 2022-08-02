#  Swipe Detector
## Author: [woodjobber](https://github.com/woodjobber)

A package to detect your swipe directions and provides you with callbacks to handle them.

## Usage

```dart
SwipeDetector(
  onSwipe: (direction) {
    print(direction);
  },
  onSwipeUp: () {
    print('up');
  },
  onSwipeDown: () {
    print('down');
  },
  onSwipeLeft: () {
    print('left');
  },
  onSwipeRight: () {
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