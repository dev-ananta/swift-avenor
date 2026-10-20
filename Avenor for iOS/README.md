# Avenor for iOS — corrected SwiftUI source

## Fixes applied
- Added `import Combine` to `AvenorStore.swift`. `ObservableObject`, `@Published`, and `ObservableObjectPublisher` are declared by Combine; this fixes the missing publisher/type errors shown in Xcode.
- Removed the manually declared `objectWillChange` publisher. `ObservableObject` synthesizes the publisher for this store from its `@Published` properties, and the uninitialized manual declaration was unnecessary.

## Requirements
- Xcode 16 or later recommended
- iOS 17+ deployment target
- Swift 5.9+

## Open/build
1. In Xcode, create **File → New → Project → iOS → App**.
2. Set Product Name to `Avenor`, Interface to **SwiftUI**, Language to **Swift**.
3. Set the iOS Deployment Target to iOS 17 or later.
4. Add the `.swift` files in this folder to the app target (ensure **Copy items if needed** and the Avenor target are selected). Keep `AvenorApp.swift` as the only `@main` entry point.
5. Ensure `Assets.xcassets` is included in the app target, then select an iOS Simulator and press **⌘B**.

The source intentionally uses native SwiftUI and local `UserDefaults`/Codable persistence. No third-party packages are required. Signing is only needed for installing on a physical device or distribution.

## Included features
- Five-tab navigation: Home, Tasks, Calendar, Classes, Profile
- Add tasks, classes, and events
- Task status filters and completion toggle
- Local persistence using `UserDefaults` + Codable
- Dark Avenor-inspired theme

## Verification status
The reported Combine-related compile errors are corrected in source. This environment does not include Xcode/iOS SDK, so an actual Xcode build and simulator run could not be performed here. Review any remaining Xcode diagnostics after adding the files to the app target.
