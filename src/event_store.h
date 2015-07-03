#pragma once
#include <pebble.h>

typedef struct {
  char side;
  time_t time;
} side_event;

bool has_event();

void persist_to_disk();
void load_from_disk();

void log_side(char side);

void set_event(side_event e);

side_event get_last_event();

/// Deletes the last event logged, making the prior event the new "last" event.
/// returns the new "last_event".
/// The store only keeps one event back, so this can only be effectively called once between user logs.
side_event undo_last_event();
