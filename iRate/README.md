# iRate 💱
![Swift](https://swift.org)
![Platform](https://developer.apple.com/ios/)
![SwiftUI](https://developer.apple.com/xcode/swiftui/)

iRate is a modern SwiftUI currency converter. It fetches live exchange rates, supports instant currency swaps, and keeps the interface clean and fast. The app includes haptics, search, and in-app language switching (English ↔ Bangla).

Screenshots 📱
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
      <img src="/screenshots/settings.png" width="250" alt="Settings Screen"/><br/>
      <em>Settings Screen</em>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="/screenshots/settings_bangla.png" width="250" alt="Settings (Bangla)"/><br/>
      <em>Settings (Bangla)</em>
    </td>
  </tr>
</table>

## Features 🚀

- **Live Currency Conversion**
  - Real-time exchange rates
  - Instant currency swap
  - Pull-to-refresh on rates list

- **Search & Selection**
  - Searchable currency picker
  - Bottom sheet selection UI
  - Flags for quick recognition

- **Experience**
  - Typewriter-style typography
  - Haptic feedback for key actions
  - In-app language toggle (English ↔ Bangla)

- **Settings**
  - About section
  - Developer profile
  - External links

## Technology Stack 💻

- **Framework:** SwiftUI
- **Architecture:** MVVM-style (ViewModels + Views)
- **Networking:** URLSession
- **API:** ExchangeRate-API (v6)
- **Localization:** Localizable.strings + in-app toggle
- **Haptics:** UIImpactFeedbackGenerator / UINotificationFeedbackGenerator

## API 🔌

Rates are fetched from:
`https://v6.exchangerate-api.com`

API key is configured in:
`/Users/newroztech/Desktop/Personal Project And R&D/currency_converter_swiftui/iRate/iRate/ViewModels/CurrencyViewModel.swift`

## Installation 🔧

1. Clone the repository
```bash
git clone https://github.com/your-username/iRate.git
```

2. Open the project in Xcode
```bash
cd iRate
open iRate.xcodeproj
```

3. Build and run

## Project Structure 🧱

- **Views:** UI components and screens
- **ViewModels:** API handling and view state
- **Utilities:** Haptics, localization, keyboard helpers
- **Assets:** App icons and images

## Localization 🌍

iRate supports English and Bangla:
- Toggle language inside Settings
- Strings live in:
  - `en.lproj/Localizable.strings`
  - `bn.lproj/Localizable.strings`

## Contributions 🤝

Contributions are welcome. Feel free to submit a Pull Request.

## License 📝

MIT (or your preferred license)

## Contact 📫

Sabbir Nasir
- LinkedIn: https://www.linkedin.com/in/sabbirn26/
- GitHub: https://github.com/sabbirn26
