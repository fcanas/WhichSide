#include <pebble.h>
#include "root_screen.h"
#include "event_store.h"

static TextLayer *status_text_layer;
static TextLayer *time_text_layer;
static ActionBarLayer *action_bar_layer;

static AppTimer *refresh_timer;

const unsigned int SECS_PER_HR  = 60 * 60;
const unsigned int SECS_PER_MIN = 60;

// static void more_click_handler(ClickRecognizerRef recognizer, void *context) {
//   text_layer_set_text(status_text_layer, "More");
//   time_t currentTime;
//   time(&time_t);
//   char[48] timeString;
//   clock_copy_time_string(timeString, sizeof(timeString));
//   text_layer_set_text(time_text_layer, );
// }

side_event last_event;

static char side_string[20];
static char time_string[20];

static void update_ui();

static void log_side_ui(const char side) {
  log_side(side);
  app_timer_reschedule(refresh_timer, 60 * 1000);
  update_ui();
}

static void left_click_handler(ClickRecognizerRef recognizer, void *context) {
  log_side_ui('L');
}

static void right_click_handler(ClickRecognizerRef recognizer, void *context) {
  log_side_ui('R');
}

static void click_config_provider(void *context) {
//   window_single_click_subscribe(BUTTON_ID_SELECT, more_click_handler);
  window_single_click_subscribe(BUTTON_ID_UP, left_click_handler);
  window_single_click_subscribe(BUTTON_ID_DOWN, right_click_handler);
}

void load_last_event_from_store() {
  last_event = get_last_event();
}

static update_date_string() {
  time_t now;
  time(&now);
  int diff = difftime(now, last_event.time);
  unsigned int hours = diff / SECS_PER_HR;
  diff = diff % SECS_PER_HR;
  unsigned int minutes = diff / SECS_PER_MIN;
  snprintf(time_string, sizeof(time_string), "%u:%02u", hours, minutes);
}

static update_time_string() {
  snprintf(side_string, sizeof(side_string), "%c", last_event.side);
}

static void update_ui() {
  load_last_event_from_store();
  update_date_string();
  update_time_string();
  text_layer_set_text(status_text_layer, side_string);
  text_layer_set_text(time_text_layer, time_string);
}

static void timer_callback(void *data) {
  update_ui();
  app_timer_register(60*1000, &timer_callback, NULL);
}

static void window_load(Window *window) {
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);
  window_set_background_color(window, GColorVividCerulean);

  GFont side_font = fonts_get_system_font(FONT_KEY_BITHAM_42_BOLD);

  // Status Label
  status_text_layer = text_layer_create((GRect) { .origin = { 0, 32 }, .size = { bounds.size.w - 30, 50 } });
  text_layer_set_background_color(status_text_layer, GColorClear);
  text_layer_set_text(status_text_layer, "");
  text_layer_set_font(status_text_layer, side_font);
  text_layer_set_text_alignment(status_text_layer, GTextAlignmentCenter);
  layer_add_child(window_layer, text_layer_get_layer(status_text_layer));

  GFont time_font = fonts_get_system_font(FONT_KEY_BITHAM_42_MEDIUM_NUMBERS);

  // Time Label
  time_text_layer = text_layer_create((GRect) { .origin = { 0, 80 }, .size = { bounds.size.w - 30, 60 } });
  text_layer_set_background_color(time_text_layer, GColorClear);
  text_layer_set_text(time_text_layer, "");
  text_layer_set_font(time_text_layer, time_font);
  text_layer_set_text_alignment(time_text_layer, GTextAlignmentCenter);
  layer_add_child(window_layer, text_layer_get_layer(time_text_layer));

    // ActionBarLabel
  action_bar_layer = action_bar_layer_create();
  action_bar_layer_add_to_window(action_bar_layer, window);
  action_bar_layer_set_click_config_provider(action_bar_layer, click_config_provider);
  action_bar_layer_set_background_color(action_bar_layer, GColorVividViolet);

  action_bar_layer_set_icon_animated(action_bar_layer, BUTTON_ID_UP, gbitmap_create_with_resource(RESOURCE_ID_SMALL_LEFT_IMG), true);
  action_bar_layer_set_icon_animated(action_bar_layer, BUTTON_ID_DOWN, gbitmap_create_with_resource (RESOURCE_ID_SMALL_RIGHT_IMG), true);

  refresh_timer = app_timer_register(60*1000, &timer_callback, NULL);

  load_last_event_from_store();
  update_ui();
}

static void window_unload(Window *window) {
  text_layer_destroy(status_text_layer);
  action_bar_layer_destroy(action_bar_layer);
  app_timer_cancel(refresh_timer);
}

WindowHandlers RootScreen = {
  .load = &window_load,
  .unload = &window_unload
};
