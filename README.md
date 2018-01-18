# MatomoTracker iOS SDK

The MatomoTracker is an iOS, tvOS and macOS SDK for sending app analytics to a Matomo (former Piwik) server. MatomoTracker can be used from Swift and [Objective-C](#objective-c-compatibility).

**Fancy help improve this SDK? Check [this list](https://github.com/matomo-org/matomo-sdk-ios/issues?utf8=✓&q=is%3Aopen%20is%3Aissue%20label%3Adiscussion%20label%3Aswift3) to see what is left and can be improved.**

[![Build Status](https://travis-ci.org/matomo-org/matomo-sdk-ios.svg?branch=develop)](https://travis-ci.org/matomo-org/matomo-sdk-ios)

## Installation
### [CocoaPods](https://cocoapods.org)

Use the following in your Podfile.

```
pod 'MatomoTracker', '~> 4.4'
```

Then run `pod install`. In every file you want to use the MatomoTracker, don't forget to import the framework with `import MatomoTracker`.

## Usage
### Configuration

Before the first usage, the MatomoTracker has to be configured. This is best done in the `application(_:, didFinishLaunchingWithOptions:)` method in the `AppDelegate`.

```
MatomoTracker.configureSharedInstance(withSiteID: "5", baseURL: URL(string: "http://your.server.org/path-to-matomo/piwik.php")!)
```

The `siteId` is the ID that you can get if you [add a website](https://matomo.org/docs/manage-websites/#add-a-website) within the Matomo web interface. The `baseURL` it the URL to your Matomo web instance and has to include the "piwik.php" string.

#### Opting Out

The MatomoTracker SDK supports opting out of tracking. Please use the `isOptedOut` property of the MatomoTracker to define if the user opted out of tracking.

```
MatomoTracker.shared?.isOptedOut = true
```

### Tracking Page Views

The MatomoTracker can track hierarchical screen names, e.g. screen/settings/register. Use this to create a hierarchical and logical grouping of screen views in the Matomo web interface.

```
MatomoTracker.shared?.track(view: ["path","to","your","page"])
```

You can also set the url of the page.
```
let url = URL(string: "https://matomo.org/get-involved/")
MatomoTracker.shared?.track(view: ["community","get-involved"], url: url)
```

### Tracking Events

Events can be used to track user interactions such as taps on a button. An event consists of four parts:

- Category
- Action
- Name (optional, recommended)
- Value (optional)

```
MatomoTracker.shared?.track(eventWithCategory: "player", action: "slide", name: "volume", value: 35.1)
```

This will log that the user slid the volume slider on the player to 35.1%.

### Custom Dimension

The Matomo SDK currently supports Custom Dimensions for the Visit Scope. Using Custom Dimensions you can add properties to the whole visit, such as "Did the user finish the tutorial?", "Is the user a paying user?" or "Which version of the Application is being used?" and such. Before sending custom dimensions please make sure Custom Dimensions are [properly installed and configured](https://matomo.org/docs/custom-dimensions/). You will need the `ID` of your configured Dimension.

After that you can set a new Dimension,

```
MatomoTracker.shared?.set(value: "1.0.0-beta2", forIndex: 1)
```

or remove an already set dimension.

```
MatomoTracker.shared?.remove(dimensionAtIndex: 1)
```

Dimensions in the Visit Scope will be sent along every Page View or Event. Custom Dimensions are not persisted by the SDK and have to be re-configured upon application startup.

### Custom User ID

To add a [custom User ID](https://matomo.org/docs/user-id/), simply set the value you'd like to use on the `visitorId` field of the shared tracker:

```
MatomoTracker.shared?.visitorId = "coolUsername123"
```

All future events being tracked by the SDK will be associated with this userID, as opposed to the default UUID created for each Visitor.

## Advanced Usage
### Manual dispatching

The MatomoTracker will dispatch events every 30 seconds automatically. If you want to dispatch events manually, you can use the `dispatch()` function. You can, for example, dispatch whenever the application enter the background.

```
func applicationDidEnterBackground(_ application: UIApplication) {
  MatomoTracker.shared?.dispatch()
}
```

### Session Management

The MatomoTracker starts a new session whenever the application starts. If you want to start a new session manually, you can use the `startNewSession()` function. You can, for example, start a new session whenever the user enters the application.

```
func applicationWillEnterForeground(_ application: UIApplication) {
  MatomoTracker.shared?.startNewSession()
}
```

### Logging

The MatomoTracker per default logs `warning` and `error` messages to the console. You can change the `LogLevel`.

```
MatomoTracker.shared?.logger = DefaultLogger(minLevel: .verbose)
MatomoTracker.shared?.logger = DefaultLogger(minLevel: .debug)
MatomoTracker.shared?.logger = DefaultLogger(minLevel: .info)
MatomoTracker.shared?.logger = DefaultLogger(minLevel: .warning)
MatomoTracker.shared?.logger = DefaultLogger(minLevel: .error)
```

You can also write your own `Logger` and send the logs wherever you want. Just write a new class/struct an let it conform to the `Logger` protocol.

### Custom User Agent
The `MatomoTracker` will create a default user agent derived from the WKWebView user agent.
You can instantiate the `MatomoTracker` using your own user agent.

```
MatomoTracker.configureSharedInstance(withSiteID: "5", baseURL: URL(string: "http://your.server.org/path-to-matomo/piwik.php")!, userAgent: "Your custom user agent")
```

### Objective-C compatibility

Version 4 of this SDK is written in Swift, but you can use it in your Objective-C project as well. If you don't want to update you can still use the unsupported older [version 3](https://github.com/matomo-org/matomo-sdk-ios/tree/version-3). Using the Swift SDK from Objective-C should be pretty straight forward.

```
[MatomoTracker configureSharedInstanceWithSiteID:@"5" baseURL:[NSURL URLWithString:@"http://your.server.org/path-to-matomo/piwik.php"] userAgent:nil];
[MatomoTracker shared] trackWithView:@[@"example"] url:nil];
[[MatomoTracker shared] trackWithEventWithCategory:@"category" action:@"action" name:nil number:nil];
[[MatomoTracker shared] dispatch];
```

### Sending custom events

Instead of using the convenience functions for events and screen views for example you can create your event manually and even send custom tracking parameters. This feature isn't available from Objective-C.

```
func sendCustomEvent() {
  guard let MatomoTracker = MatomoTracker.shared else { return }
  let downloadURL = URL(string: "https://builds.matomo.org/piwik.zip")!
  let event = Event(tracker: MatomoTracker, action: ["menu", "custom tracking parameters"], url: downloadURL, customTrackingParameters: ["download": downloadURL.absoluteString])
  MatomoTracker.shared?.track(event)
}
```

All custom events will be URL-encoded and dispatched along with the default Event parameters. Please read the [Tracking API Documentation](https://developer.matomo.org/api-reference/tracking-api) for more information on which parameters can be used.

Also: You cannot override Custom Parameter keys that are already defined by the Event itself. If you set those keys in the `customTrackingParameters` they will be discarded.

### Automatic url generation

You can define the url property on every `Event`. If none is defined, the SDK will try to generate a url based on the `contentBase` of the `MatomoTracker`. If the `contentBase` is nil, no url will be generated. If the `contentBase` is set, it will append the actions of the event to it and use it as the url. Per default the `contentBase` is generated using the application bundle identifier. For example `http://org.matomo.skd`. This will not result in resolvable urls, but enables the backend to analyse and structure them.

### Event dispatching

Whenever you track an event or a page view it is stored in memory first. In every dispatch run a batch of thos events are sent to the server. If the device is offline or the server doesn't respond these events will be kept and resent at a later time. Events currently aren't stored on disk and will be lost if the application is terminated. [#137](https://github.com/matomo-org/matomo-sdk-ios/issues/137)

## Contributing
Please read [CONTRIBUTING.md](https://github.com/matomo-org/matomo-sdk-ios/blob/swift3/CONTRIBUTING.md) for details.

## ToDo
### These features aren't implemented yet

- Basic functionality
  - [Persisting non dispatched events](https://github.com/matomo-org/matomo-sdk-ios/issues/137)
- Tracking of more things
  - Exceptions
  - Social Interactions
  - Search
  - Goals and Conversions
  - Outlinks
  - Downloads
  - [Ecommerce Transactions](https://github.com/matomo-org/matomo-sdk-ios/issues/110)
  - [Campaigns](https://github.com/matomo-org/matomo-sdk-ios/issues/109)
  - Content Impressions / Content Interactions
- Customizing the tracker
  - add prefixing? (The objc-SDK had a prefixing functionality ![Example screenshot](http://matomo-org.github.io/matomo-sdk-ios/piwik_prefixing.png))
  - set the dispatch interval
  - use different dispatchers (Alamofire)

## License

MatomoTracker is available under the [MIT license](LICENSE.md).
