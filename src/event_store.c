#include "event_store.h"
#include <pebble.h>

#define LAST_SIDE_STRING_KEY 10
#define LAST_TIME_KEY 20
#define LAST_EVENT_KEY 1

void log_side(char side) {
  time_t now;
  time(&now);
  side_event e = { .side = side, .time = now };
  set_event(e);
}

void set_event(side_event e) {
  persist_write_data(LAST_EVENT_KEY, &e, sizeof(e));
}

side_event get_last_event() {
  side_event e;
  persist_read_data(LAST_EVENT_KEY, &e, sizeof(e));
  return e;
}
