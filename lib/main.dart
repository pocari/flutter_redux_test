import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(CounterScreen(
    store: Store<CounterState>(
      reducers,
      initialState: CounterState(counter: 0),
    ),
    title: 'Flutter Redux Sample'));

@immutable
class CounterState {
  final int counter;

  const CounterState({this.counter});
}

class IncrementAction {}

CounterState counterIncrementReducer(
        CounterState state, IncrementAction action) =>
    CounterState(counter: state.counter + 1);

class DecrementAction {}

CounterState counterDecrementReducer(
        CounterState state, DecrementAction action) =>
    CounterState(counter: state.counter - 1);

final reducers = combineReducers<CounterState>([
  TypedReducer<CounterState, IncrementAction>(counterIncrementReducer),
  TypedReducer<CounterState, DecrementAction>(counterDecrementReducer),
]);

class CounterScreen extends StatelessWidget {
  final Store<CounterState> store;
  final String title;

  CounterScreen({Key key, this.store, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreProvider(
        store: store,
        child: MaterialApp(
          theme: ThemeData.dark(),
          title: title,
          home: Scaffold(
            appBar: AppBar(title: Text(title)),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StoreConnector<CounterState, String>(
                    converter: (store) => store.state.counter.toString(),
                    builder: (context, count) {
                      return Text(count,
                          style: Theme.of(context).textTheme.display1);
                    },
                  )
                ],
              ),
            ),
            floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StoreConnector<CounterState, VoidCallback>(
                    converter: (store) =>
                        () => store.dispatch(IncrementAction()),
                    builder: (context, callback) => FloatingActionButton(
                      onPressed: callback,
                      tooltip: 'Increment',
                      child: Icon(Icons.add),
                    ),
                  ),
                  StoreConnector<CounterState, VoidCallback>(
                    converter: (store) =>
                        () => store.dispatch(DecrementAction()),
                    builder: (context, callback) => FloatingActionButton(
                      onPressed: callback,
                      tooltip: 'Decrement',
                      child: Icon(Icons.remove),
                    ),
                  ),
                ]),
          ),
        ),
      );
}
