library scheduler;
import 'dart:async' show Timer;
import 'package:webhook_proxy/config.dart' show Config;

typedef dynamic SchedPayload();

abstract class SchedHandler {
    /// Update handler with a new time frame and execute code accordingly.
    /// Returns `false` if this handler should be detached from the scheduler.
    bool update(DateTime now);
}

class Scheduler {
    List<SchedHandler> _handlers;

    /// Creates a `Scheduler` that polls system time every [quantum] and updates all handlers attached.
    Scheduler(Config cfg) {
        _handlers = new List<SchedHandler>();
        new Timer.periodic(cfg.quantum, (t) {
            DateTime now = new DateTime.now();
            _handlers.retainWhere((h) => h.update(now));
        });
    }

    /// Attach `SchedHandler` [h] to this `Scheduler`.
    attach(SchedHandler h) => _handlers.add(h);
}

class SingletonHandler implements SchedHandler {
    SchedPayload payload;
    DateTime target;

    /// Creates a `SingletonHandler` that will execute [payload] once [target] is reached.
    /// [payload] will execute during the next quantum if [target] is not in the future.
    SingletonHandler(this.payload, this.target);

    bool update(DateTime now) {
        if(now.isAfter(target)) {
            payload();
            return false;
        }
        return true;
    }
}

class DailyHandler implements SchedHandler {
    SchedPayload payload;
    Duration time;
    DateTime lastRan;

    /// Creates a `DailyHandler` that will execute [payload] everyday [time] after midnight.
    DailyHandler(this.payload, this.time) {
        lastRan = new DateTime.fromMillisecondsSinceEpoch(0);
    }

    bool update(DateTime now) {
        DateTime today = new DateTime(now.year, now.month, now.day);
        if(now.isAfter(today.add(time)) && lastRan.isBefore(today)) {
            lastRan = today;
            payload();
        }
        return true;
    }
}

class PeriodicHandler implements SchedHandler {
    SchedPayload payload;
    Duration duration;
    DateTime executed;

    /// Creates a `PeriodicHandler` that will execute [payload] every [duration].
    PeriodicHandler(this.payload, this.duration) {
        executed = new DateTime.fromMillisecondsSinceEpoch(0);
    }

    bool update(DateTime now) {
        if(now.isAfter(executed.add(duration))) {
            executed = new DateTime.now();
            payload();
        }
        return true;
    }
}

class QuantumHandler extends PeriodicHandler {

    /// Creates a `QuantumHandler` that will execute [payload] every quantum.
    QuantumHandler(payload): super(payload, new Duration());
}


