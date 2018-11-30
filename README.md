# VKKeyboardManager

## Requirements:

- iOS 8 or higher

- Swift 3 or higher


## Usage:
- Drag and drop "VKKeyboardManager" folder into your resource

```
// add this code in "AppDelegate.swift" didFinishLaunchingWithOptions function...
VKKeyboardManager.shared.setEnable()
VKKeyboardManager.shared.keyboard_gap = 5.0 // default vaule 5.0 and max 100.0
```

```
// if any screen you don't want this disable this
VKKeyboardManager.shared.setDisable()
```

```
// move to back or next again enable this
VKKeyboardManager.shared.setEnable()

```
