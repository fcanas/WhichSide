#include <pebble.h>
#include "root_screen.h"
  
static Window *window;

static void init(void) {
  window = window_create();
  window_set_window_handlers(window, RootScreen);
  const bool animated = true;
  window_stack_push(window, animated);
}

static void deinit(void) {
  window_destroy(window);
}

int main(void) {
  init();
  app_event_loop();
  deinit();
}