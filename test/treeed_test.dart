import 'package:test/test.dart';
import 'package:treeed/treeed.dart';

void main() {
  treeedStateTests();
}

void treeedStateTests() {
  test('TreeedState updates listeners on `set` invokations.', () {
    final state = TreeedState(0);
    var gotNewVal = false;

    state.listen((_) => gotNewVal = true);
    state.set(1);
    expect(gotNewVal, equals(true));

    state.dispose();
  });

  test('TreeedState updated value is stored correctly.', () {
    final state = TreeedState(0);
    expect(state.get, equals(0));

    state.set(1);
    expect(state.get, equals(1));

    state.listen((_) => state.quietSet(50));
    state.set(2);
    expect(state.get, equals(50));

    state.dispose();
  });

  test('TreeedState unlistens the observer-function.', () {
    final state = TreeedState(0);
    var updatingToggler = false;

    observer(_) => updatingToggler = !updatingToggler;

    state.listen(observer);
    state.set(state.get);
    expect(updatingToggler, equals(true));

    state.unlisten(observer);
    state.set(state.get);
    expect(updatingToggler, equals(true));

    state.dispose();
  });

  test('TreeedState provides correct new value for listenres (observers).', () {
    final state = TreeedState(0);
    state.listen((int newVal) => expect(newVal, equals(state.get)));
    state.set(1);
    state.dispose();
  });
}
