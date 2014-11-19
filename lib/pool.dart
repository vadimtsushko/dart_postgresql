library postgresql.pool;

import 'dart:async';
import 'package:postgresql/postgresql.dart' as pg;
import 'package:postgresql/src/pool_impl_cps.dart';

//TODO docs
//TODO expose more getters from PoolImpl
abstract class Pool {
  factory Pool(String databaseUri, [PoolSettings settings])
    => new PoolImpl(databaseUri, settings);
  Future start();
  Future stop();
  Future<pg.Connection> connect({String debugId});
  Stream<pg.Message> get messages;
}

abstract class PoolSettings {

  factory PoolSettings({String poolName,
      int minConnections,
      int maxConnections,
      Duration startTimeout,
      Duration stopTimeout,
      Duration establishTimeout,
      Duration connectionTimeout,
      Duration idleTimeout,
      Duration maxLifetime,
      Duration leakDetectionThreshold,
      bool testConnections,
      bool restartIfAllConnectionsLeaked,
      pg.TypeConverter typeConverter}) = PoolSettingsImpl;

  String get poolName;
  int get minConnections;
  int get maxConnections;
  Duration get startTimeout;
  Duration get stopTimeout;
  Duration get establishTimeout; //TODO better name
  Duration get connectionTimeout; //TODO better name
  Duration get idleTimeout;
  Duration get maxLifetime;
  Duration get leakDetectionThreshold;
  bool get testConnections;
  bool get restartIfAllConnectionsLeaked;
  pg.TypeConverter get typeConverter;
}

//TODO change to enum once implemented.
class PoolState {
  const PoolState(this.name);
  final String name;
  toString() => name;

  static const PoolState initial = const PoolState('inital');
  static const PoolState starting = const PoolState('starting');
  static const PoolState running = const PoolState('running');
  static const PoolState stopping = const PoolState('stopping');
  static const PoolState stopped = const PoolState('stopped');
}

//TODO change to enum once implemented.
class PooledConnectionState {
  const PooledConnectionState(this.name);
  final String name;
  toString() => name;

  static const PooledConnectionState connecting = const PooledConnectionState('connecting');
  static const PooledConnectionState testing = const PooledConnectionState('testing');
  static const PooledConnectionState available = const PooledConnectionState('available');
  static const PooledConnectionState inUse = const PooledConnectionState('inUse');
  static const PooledConnectionState closed = const PooledConnectionState('closed');
}
