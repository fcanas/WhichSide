#include <pebble.h>
#include "root_screen.h"

static TextLayer *status_text_layer;
static TextLayer *time_text_layer;
static ActionBarLayer *action_bar_layer;

static void more_click_handler(ClickRecognizerRef recognizer, void *context) {
  text_layer_set_text(status_text_layer, "More");
  text_layer_set_text(time_text_layer, );
}

static void left_click_handler(ClickRecognizerRef recognizer, void *context) {
  text_layer_set_text(status_text_layer, "Left");
}

static void right_click_handler(ClickRecognizerRef recognizer, void *context) {
  text_layer_set_text(status_text_layer, "Right");
}

static void click_config_provider(void *context) {
  window_single_click_subscribe(BUTTON_ID_SELECT, more_click_handler);
  window_single_click_subscribe(BUTTON_ID_UP, left_click_handler);
  window_single_click_subscribe(BUTTON_ID_DOWN, right_click_handler);
}
  
static void window_load(Window *window) {
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);
  window_set_background_color(window, GColorVividCerulean);

  GFont font = fonts_get_system_font(FONT_KEY_ROBOTO_CONDENSED_21);
  
  // Status Label
  status_text_layer = text_layer_create((GRect) { .origin = { 0, 52 }, .size = { bounds.size.w - 30, 30 } });
  text_layer_set_background_color(status_text_layer, GColorClear);
  text_layer_set_text(status_text_layer, "");
  text_layer_set_font(status_text_layer, font);
  text_layer_set_text_alignment(status_text_layer, GTextAlignmentCenter);
  layer_add_child(window_layer, text_layer_get_layer(status_text_layer));
  
  // Time Label
  time_text_layer = text_layer_create((GRect) { .origin = { 0, 80 }, .size = { bounds.size.w - 30, 30 } });
  text_layer_set_background_color(time_text_layer, GColorClear);
  text_layer_set_text(time_text_layer, "");
  text_layer_set_font(time_text_layer, font);
  text_layer_set_text_alignment(time_text_layer, GTextAlignmentCenter);
  layer_add_child(window_layer, text_layer_get_layer(time_text_layer));
  
    // ActionBarLabel
  action_bar_layer = action_bar_layer_create();
  action_bar_layer_add_to_window(action_bar_layer, window);
  action_bar_layer_set_click_config_provider(action_bar_layer, click_config_provider);
  action_bar_layer_set_background_color(action_bar_layer, GColorIslamicGreen);
  
//   action_bar_layer_set_icon_animated(action_bar, BUTTON_ID_UP, my_icon_previous, true);
//   action_bar_layer_set_icon_animated(action_bar, BUTTON_ID_DOWN, my_icon_next, true);
  
}

static void window_unload(Window *window) {
  text_layer_destroy(status_text_layer);
  action_bar_layer_destroy(action_bar_layer);
}

WindowHandlers RootScreen = {
  .load = &window_load,
  .unload = &window_unload
};
