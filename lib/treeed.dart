/// Base class for any updatable state model in Treeed.
/// ---
/// If you wish to create your own state-managing behavior based on this class then use inheritance, like that:
/// ```dart
/// class MyState<T> extends TreeedUpdatable<T> {
///   TreeedState(T value) : _value = value;
///
///   T _value;
///
///   T get get => _value;
///
///   void set(T value) {
///     _value = value;
///     _triggerUpdating(value);
///   }
///
///   @override
///   void listen(void Function(T) fn) {
///     _listeners.add(fn);
///   }
///
///   @override
///   void unlisten(void Function(T) fn) {
///     _listeners.remove(fn);
///   }
/// }
/// ```
abstract class TreeedUpdatable<T> {
  /// Adds the `fn` function to the listeners list.
  void listen(void Function(T) fn);

  /// Removes the `fn` function from the listeners list.
  void unlisten(void Function(T) fn);

  final _listeners = List<void Function(T)>.empty(growable: true);

  void _triggerUpdating(T newValue) {
    var listenersSize = _listeners.length;
    for (int i = 0; i < listenersSize; ++i) {
      final keyFn = _listeners[i];
      keyFn(newValue);
    }
  }

  /// Clears everything.
  void dispose() => _listeners.clear();
}

/// Treeed state value wrapper. Use it for wrapping a value you want to observe with updating events.
class TreeedState<T> extends TreeedUpdatable<T> {
  /// Treeed state value wrapper. Use it for wrapping a value you want to observe with updating events.
  /// Example:
  /// ```dart
  /// final myValue = TreeedState(0); // Initializing the state with value `0`.
  /// print(myValue.get); // Reading the wrapped value in the state.
  ///
  /// final subscribingFn = (newValue) => print(newValue);
  /// myValue.listen(subscribingfn); // Subscribing to events.
  ///
  /// myValue.set(42); // Setting new value to the state. All listeners will be called at this point.
  /// myValue.quietSet(24); // Setting new value to the state but no listeners will be called.
  ///
  /// myValue.unlisten(subscribingfn); // Unsubscribing from updates.
  /// ```
  TreeedState(T value) : _value = value;

  T _value;

  /// Returns the stored value.
  T get get => _value;

  /// Updating the stored value and calling all listeners.
  void set(T value) {
    _value = value;
    _triggerUpdating(value);
  }

  /// Updating the stored value but without calling any listeners.
  void quietSet(T value) {
    _value = value;
  }

  @override
  void listen(void Function(T) fn) {
    _listeners.add(fn);
  }

  @override
  void unlisten(void Function(T) fn) {
    _listeners.remove(fn);
  }
}

/// Treeed group of states. Use it as a parent class for your states directives (aka tree branch) or services / controllers.
/// Example:
/// ```dart
/// MyState extends TreeedGroup {
///     // Use function `treeedState` for automatically subscribe the group to updates of this state.
///     late final someAutoSubscribedByGroupState = treeedState(0);
///
///     // ts = treeedState.
///     late final shorterWay = ts(0);
///
///     // Use the `TreeedState` class constructor for creating simple value state.
///     final someSimpleState = TreeedState(42);
/// }
/// ```
class TreeedGroup extends TreeedUpdatable<TreeedGroup> {
  /// Constructor of `TreeedGroup`. It's not the common way to use this type, try to extending it by your class.
  TreeedGroup();

  void _theHolyUpdatingWrapper(dynamic _) => _triggerUpdating(this);

  /// `treeedState<T>` function that constructs the `TreeedState<T>` and automatically subscribes the group to it's updates.
  /// ---
  /// `initValue`: initial value of the constructed state.
  /// `firstListener`: function that will be additionally added to the state's listeners list.
  TreeedState<T> treeedState<T>(
    T initValue, {
    void Function(T)? firstListener,
  }) {
    final state = TreeedState(initValue);
    if (firstListener != null) state.listen(firstListener);
    state.listen(_theHolyUpdatingWrapper);
    return state;
  }

  /// Shortening for `treeedState<T>`.
  late final ts = treeedState;

  /// `treeedGroup<T>` acts like `treeedState<T>` but constructing the inner group of that group.
  T treeedGroup<T extends TreeedGroup>(T group) =>
      group..listen(_theHolyUpdatingWrapper);

  /// Shortening for `treeedGroup<T>`.
  late final tg = treeedGroup;

  @override
  void listen(void Function(TreeedGroup) fn) {
    _listeners.add(fn);
  }

  @override
  void unlisten(void Function(TreeedGroup) fn) {
    _listeners.remove(fn);
  }

  /// Triggering an update event for that specific group without triggering any inner states.
  void triggerUpdate() => _triggerUpdating(this);
}
