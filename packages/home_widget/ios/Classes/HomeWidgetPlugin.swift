import Flutter
import UIKit

public class HomeWidgetPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "home_widget", binaryMessenger: registrar.messenger())
    let instance = HomeWidgetPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "saveWidgetData":
      // Stub implementation
      result(nil)
    case "getWidgetData":
      // Stub implementation
      result(nil)
    case "updateWidget":
      // Stub implementation
      result(nil)
    case "registerBackgroundCallback":
      // Stub implementation
      result(nil)
    case "setAppGroupId":
      // Stub implementation
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}