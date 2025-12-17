import 'package:test/test.dart';
import 'package:treeed/treeed.dart';

void main() {
  treeedStateTests();
}

void treeedStateTests() {
  test('TreeedState updates listeners on `set` invokations.', () {
    final state = TState(0);
    var gotNewVal = false;

    state.listen((_) => gotNewVal = true);
    state.set(1);
    expect(gotNewVal, equals(true));

    state.dispose();
  });

  test('TreeedState updated value is stored correctly.', () {
    final state = TState(0);
    expect(state.get, equals(0));

    state.set(1);
    expect(state.get, equals(1));

    state.listen((_) => state.quietSet(50));
    state.set(2);
    expect(state.get, equals(50));

    state.dispose();
  });

  test('TreeedState unlistens the observer-function.', () {
    final state = TState(0);
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
    final state = TState(0);
    state.listen((int newVal) => expect(newVal, equals(state.get)));
    state.set(1);
    state.dispose();
  });

  test(
    'TreeedState.when observation runs the provided action whenever the provided condition is returning true.',
    () {
      final state = CTState(0);
      state.when((x) => x % 2 == 0, (x) => state.set(x + 1));

      state.set(1); // Does not call the action of `when` observer.
      expect(state.get, equals(1));

      state.set(2); // Does call the action and so incrementing the state value.
      expect(state.get, equals(3));
    },
  );

  test(
    'TreeedState.whenEqual observation runs the provided action whenever the provided constant value is equal to a new updated value.',
    () {
      final state = CTState(0);
      state.whenEquals(2, () => state.set(3));

      state.set(1); // Does not call the action.
      expect(state.get, equals(1));

      state.set(2); // Does call the action and so set the state value as 3.
      expect(state.get, equals(3));
    },
  );

  test('TreeedState.setAsync method can be paralleled.', () {
    final state = TState("initial");

    () async {
      await Future.delayed(Duration(seconds: 1)); // Doing some work.
      expect(
        state.get,
        equals("non-async"),
      ); // The non-async block (after that Future block) must set 2 to the `state` before 1 second lasts.
      await state.asyncSet("async");
      expect(state.get, equals("async"));
    }().onError((err, stack) => throw err ?? Error());

    state.set("non-async");
    expect(state.get, equals("non-async"));
  });
}
