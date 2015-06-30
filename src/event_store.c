#include "event_store.h"
#include <pebble.h>

#define LAST_SIDE_STRING_KEY 10
#define LAST_TIME_KEY 20
#define LAST_EVENT_KEY 1

static side_event latest_logged_event;

void log_side(char side) {
  time_t now;
  time(&now);
  side_event e = { .side = side, .time = now };
  set_event(e);
}

void set_event(side_event e) {
  persist_to_disk();
  latest_logged_event = e;
}

void persist_to_disk() {
  persist_write_data(LAST_EVENT_KEY, &latest_logged_event, sizeof(latest_logged_event));
}

void load_from_disk() {
  persist_read_data(LAST_EVENT_KEY, &latest_logged_event, sizeof(latest_logged_event));
}

side_event get_last_event() {
  return latest_logged_event;
}

side_event undo_last_event() {
  load_from_disk();
  return latest_logged_event;
}
