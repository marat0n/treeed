abstract class TreeedUpdatable<T> {
  void listen(void Function(T) fn);
  void unlisten(void Function(T) fn);

  final _listeners = List<void Function(T)>.empty(growable: true);

  void _triggerUpdating(T newValue) {
    var listenersSize = _listeners.length;
    for (int i = 0; i < listenersSize; ++i) {
      final keyFn = _listeners[i];
      keyFn(newValue);
    }
  }
}

class TreeedState<T> extends TreeedUpdatable<T> {
  TreeedState(T value) : _value = value;

  T _value;

  T get get => _value;

  void set(T value) {
    _value = value;
    _triggerUpdating(value);
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

class TreeedGroup extends TreeedUpdatable<TreeedGroup> {
  TreeedGroup() : super();

  void _theHolyUpdatingWrapper(dynamic _) => _triggerUpdating(this);

  TreeedState<T> treeedState<T>(T initValue) =>
      TreeedState(initValue)..listen(_theHolyUpdatingWrapper);

  T treeedGroup<T extends TreeedGroup>(T group) =>
      group..listen(_theHolyUpdatingWrapper);

  @override
  void listen(void Function(TreeedGroup) fn) {
    _listeners.add(fn);
  }

  @override
  void unlisten(void Function(TreeedGroup) fn) {
    _listeners.remove(fn);
  }
}
