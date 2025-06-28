package es.antonborri.home_widget;

import android.content.Context;
import android.content.SharedPreferences;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** HomeWidgetPlugin */
public class HomeWidgetPlugin implements FlutterPlugin, MethodCallHandler {
  private MethodChannel channel;
  private static final String SHARED_PREFERENCES_NAME = "home_widget";
  private Context context;

  /**
   * Get the SharedPreferences instance used by the plugin
   * @param context The context to use
   * @return The SharedPreferences instance
   */
  public static SharedPreferences getData(Context context) {
    return context.getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE);
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "home_widget");
    context = flutterPluginBinding.getApplicationContext();
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "saveWidgetData":
        try {
          String id = call.argument("id");
          Object data = call.argument("data");
          if (id != null) {
            SharedPreferences prefs = getData(context);
            SharedPreferences.Editor editor = prefs.edit();

            if (data instanceof String) {
              editor.putString(id, (String) data);
            } else if (data instanceof Integer) {
              editor.putInt(id, (Integer) data);
            } else if (data instanceof Boolean) {
              editor.putBoolean(id, (Boolean) data);
            } else if (data instanceof Float) {
              editor.putFloat(id, (Float) data);
            } else if (data instanceof Long) {
              editor.putLong(id, (Long) data);
            }

            editor.apply();
          }
          result.success(null);
        } catch (Exception e) {
          result.error("SAVE_ERROR", e.getMessage(), null);
        }
        break;
      case "getWidgetData":
        try {
          String id = call.argument("id");
          if (id != null) {
            SharedPreferences prefs = getData(context);
            if (prefs.contains(id)) {
              // Try to get the value as different types
              if (prefs.contains(id + "_type")) {
                String type = prefs.getString(id + "_type", "");
                if ("string".equals(type)) {
                  result.success(prefs.getString(id, null));
                } else if ("int".equals(type)) {
                  result.success(prefs.getInt(id, 0));
                } else if ("bool".equals(type)) {
                  result.success(prefs.getBoolean(id, false));
                } else if ("float".equals(type)) {
                  result.success(prefs.getFloat(id, 0.0f));
                } else if ("long".equals(type)) {
                  result.success(prefs.getLong(id, 0L));
                } else {
                  result.success(null);
                }
              } else {
                // Default to string if no type is specified
                result.success(prefs.getString(id, null));
              }
            } else {
              result.success(null);
            }
          } else {
            result.success(null);
          }
        } catch (Exception e) {
          result.error("GET_ERROR", e.getMessage(), null);
        }
        break;
      case "updateWidget":
        try {
          String widgetName = call.argument("android");
          if (widgetName != null && !widgetName.isEmpty()) {
            // Create an intent to update the widget
            android.content.Intent intent = new android.content.Intent(context, Class.forName(context.getPackageName() + "." + widgetName));
            intent.setAction(android.appwidget.AppWidgetManager.ACTION_APPWIDGET_UPDATE);

            // Get all widget ids
            android.appwidget.AppWidgetManager appWidgetManager = android.appwidget.AppWidgetManager.getInstance(context);
            android.content.ComponentName componentName = new android.content.ComponentName(context, Class.forName(context.getPackageName() + "." + widgetName));
            int[] appWidgetIds = appWidgetManager.getAppWidgetIds(componentName);

            // Add the widget ids to the intent
            intent.putExtra(android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds);

            // Send the broadcast
            context.sendBroadcast(intent);
          }
          result.success(null);
        } catch (Exception e) {
          result.error("UPDATE_ERROR", e.getMessage(), null);
        }
        break;
      case "registerBackgroundCallback":
        // For Android, we don't need to do anything special for background callbacks
        // as they are handled by the AppWidgetProvider's onUpdate method
        result.success(null);
        break;
      case "setAppGroupId":
        // This is only relevant for iOS, but we'll store it in SharedPreferences anyway
        try {
          String groupId = call.argument("groupId");
          if (groupId != null) {
            SharedPreferences prefs = getData(context);
            SharedPreferences.Editor editor = prefs.edit();
            editor.putString("app_group_id", groupId);
            editor.apply();
          }
          result.success(null);
        } catch (Exception e) {
          result.error("APP_GROUP_ERROR", e.getMessage(), null);
        }
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
