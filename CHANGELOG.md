## 0.1.0
Added:
- `ConditionalTreeedState` type that extends `TreeedState` with `when` and `whenEquals` methods;
- `ConditionalTreeedState :: when` method that wraps provided action by provided condition and adds it to the state listeners list;
- `ConditionalTreeedState :: whenEquals` method that fires the provided actions when provided constant value equals to state's value;
- Typedefs (aliases): TState for TreeedState, TGroup for TreeedGroup, CTState for ConditionalTreeedState, TUpdatable for TreeedUpdatable;

## 0.0.5
Improved documentation + minor fixes

## 0.0.4
Added:
- `TreeedUpdatable :: dispose`, the cleaning method;
- `TreeedState :: quietSet` method that updates value without notifying any listeners.

## 0.0.3
Added:
- `TreeedGroup :: ts`, the shortening for `TreeedGroup :: treeedState`;
- `TreeedGroup :: tg`, the shortening for `TreeedGroup :: treeedGroup`.

## 0.0.2

Added:
- Inline docs with examples;
- `firstListener` param for `TreeedGroup :: treeedState`;
- `triggerUpdate` function for `TreeedGroup`.

## 0.0.1

- Initial version.
