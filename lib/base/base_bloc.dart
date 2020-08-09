
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutterappbookstore/base/base_event.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  StreamController<BaseEvent> _eventStreamController = StreamController<BaseEvent>();
  StreamController<bool> _loadingStreamController = StreamController<bool>();
  StreamController<BaseEvent> _processEventSubject = BehaviorSubject<BaseEvent>();

  Sink<BaseEvent> get event => _eventStreamController.sink;

  Stream<bool> get loadingStream => _loadingStreamController.stream;
  Sink<bool> get loadingSink => _loadingStreamController.sink;

  Stream<BaseEvent> get processEventStream => _processEventSubject.stream;
  Sink<BaseEvent> get processEventSink => _processEventSubject.sink;

  BaseBloc(){
    _eventStreamController.stream.listen((event) {
      if(event is! BaseEvent){
        throw Exception('Invalid event');
      }

      dispatchEvent(event);
    });
  }

  void dispatchEvent(BaseEvent event);

  @mustCallSuper
  void dispose(){
    _eventStreamController.close();
    _loadingStreamController.close();
    _processEventSubject.close();
  }

}



