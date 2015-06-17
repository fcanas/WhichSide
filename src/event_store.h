#pragma once
#include <pebble.h>
  
typedef struct {
  char side;
  time_t time;
} side_event;

void log_side(char side);

void set_event(side_event e);

side_event get_last_event();
