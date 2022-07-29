/// Rotate array right between l and r. r is included."""
void rotateRight(List arr, int l, int r) {
  var temp = arr[r];
  for (var i in range(r, l, -1)) {
    arr[i] = arr[i - 1];
  }
  arr[l] = temp;
}

/// Rotate array left between l and r. r is included.
void rotateLeft(List arr, int l, int r) {
  var temp = arr[l];
  for (var i in range(l, r)) {
    arr[i] = arr[i + 1];
  }
  arr[r] = temp;
}

/// Generate a sequence of integers
Iterable<int> range(int a, int b, [int step = 1]) sync* {
  if (step > 0) {
    for (int i = a; i < b; i += step) yield i;
  }

  if (step < 0) {
    for (int i = a; i > b; i += step) yield i;
  }
}

/// Binomial coefficient [n choose k].
///
int coeffNchooseK(int n, int k) {
  if (n < k) return 0;

  if (k > (n / 2).floor()) {
    k = n - k;
  }

  var s = 1;
  var i = n;
  var j = 1;

  while (i != n - k) {
    s *= i;
    s = (s / j).floor();
    i -= 1;
    j += 1;
  }
  return s;
}
