# iRate 💱

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)](https://developer.apple.com/xcode/swiftui/)

iRate is a modern SwiftUI currency converter that fetches live exchange rates, supports instant swaps, and presents a clean, minimal UI with haptics and localization.

## Screenshots 📱

Replace with your actual image paths.

<table>
  <tr>
    <td align="center">
      <img src="/screenshots/home.png" width="250" alt="Home Screen"/><br/>
      <em>Home Screen</em>
    </td>
    <td align="center">
      <img src="/screenshots/picker.png" width="250" alt="Currency Picker"/><br/>
      <em>Currency Picker</em>
    </td>
    <td align="center">
      <img src="/screenshots/settings.png" width="250" alt="Settings"/><br/>
      <em>Settings</em>
    </td>
  </tr>
</table>

## Features 🚀

- Live currency conversion using ExchangeRate API
- Instant currency swap
- Pull‑to‑refresh rates list
- Searchable currency picker (bottom sheet)
- Haptic feedback for key actions
- In‑app language toggle (English ↔ Bangla)
- Modern SwiftUI UI with typewriter‑style typography
- Settings screen with developer profile and links

## Tech Stack 💻

- Framework: SwiftUI
- Architecture: MVVM‑style (ViewModels + Views)
- Networking: URLSession
- Localization: Localizable.strings with in‑app language toggle
- Haptics: UIImpactFeedbackGenerator / UINotificationFeedbackGenerator

## API 🔌

Rates are fetched from:
`https://v6.exchangerate-api.com`

You can configure your API key in:
`CurrencyViewModel.swift`

## Installation 🔧

1. Clone the repo

```bash
git clone https://github.com/sabbirn26/iRate.git
```
