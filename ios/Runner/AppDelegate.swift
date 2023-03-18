import UIKit
import Flutter
import GoogleMaps 

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

 GMSServices.provideAPIKey("AIzaSyCp5EfjwJY4StgxAWjIIKim2tJ0N8L2TUw")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
