# Futures Widget

iOS app displaying live commodity futures prices (Corn, Wheat, Oil) in a home screen widget.

## Features

- Live futures prices from Yahoo Finance API
- Medium-sized home screen widget
- 5-minute auto-refresh
- Pull-to-refresh in main app
- Color-coded price changes (green/red)

## Commodities Tracked

| Symbol | Name |
|--------|------|
| CL=F | Crude Oil Futures |
| ZC=F | Corn Futures |
| ZW=F | Wheat Futures |

## Setup Instructions

### 1. Create Xcode Project

1. Open Xcode and create a new iOS App project
2. Product Name: `FuturesWidget`
3. Interface: SwiftUI
4. Language: Swift

### 2. Add Source Files

Copy the Swift files from this repo into your Xcode project:

**Main App Target:**
- `FuturesWidget/FuturesWidgetApp.swift`
- `FuturesWidget/ContentView.swift`
- `FuturesWidget/Models/FuturesPrice.swift`
- `FuturesWidget/Services/YahooFinanceService.swift`
- `FuturesWidget/Views/PriceRowView.swift`

### 3. Add Widget Extension

1. File > New > Target
2. Select "Widget Extension"
3. Product Name: `FuturesWidgetExtension`
4. Uncheck "Include Configuration App Intent"

**Widget Extension Target:**
- `FuturesWidgetExtension/FuturesWidgetBundle.swift`
- `FuturesWidgetExtension/FuturesWidget.swift`
- `FuturesWidgetExtension/Provider.swift`
- `FuturesWidgetExtension/WidgetViews/MediumWidgetView.swift`

### 4. Share Files Between Targets

The following files need to be included in BOTH targets:
- `FuturesPrice.swift`
- `YahooFinanceService.swift`

Select each file in Xcode, open the File Inspector, and check both targets under "Target Membership".

### 5. Build and Run

1. Select your iPhone simulator or device
2. Build and run the app (Cmd+R)
3. To add widget: Long press home screen > Edit > + > Search "Futures"

## Project Structure

```
FuturesWidget/
├── FuturesWidgetApp.swift      # App entry point
├── ContentView.swift           # Main app view
├── Models/
│   └── FuturesPrice.swift      # Data model
├── Services/
│   └── YahooFinanceService.swift  # API client
└── Views/
    └── PriceRowView.swift      # Price row component

FuturesWidgetExtension/
├── FuturesWidgetBundle.swift   # Widget bundle
├── FuturesWidget.swift         # Widget configuration
├── Provider.swift              # Timeline provider
└── WidgetViews/
    └── MediumWidgetView.swift  # Widget UI
```

## API

Uses Yahoo Finance public API:
```
https://query1.finance.yahoo.com/v7/finance/quote?symbols=CL=F,ZC=F,ZW=F
```

No API key required.
