# Screenshot capture flow

Real captures from the iOS Simulator via an integration-test driver (no mockups).

## Steps

1. Boot the simulator:
   ```bash
   xcrun simctl boot "iPhone 17 Pro"
   open -a Simulator
   ```
2. Scaffold the iOS platform folder (lib-only project) and get dependencies:
   ```bash
   flutter create . --platforms=ios --project-name flutter_livestock_homestead
   flutter pub get
   ```
3. Drive the screenshot test:
   ```bash
   flutter drive \
     --driver test_driver/integration_test.dart \
     --target integration_test/screenshot_test.dart \
     -d "iPhone 17 Pro"
   ```
4. Build the demo GIF from the PNGs:
   ```bash
   cd screenshots
   ffmpeg -y -framerate 1 -pattern_type glob -i '*.png' \
     -vf "scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
     -loop 0 demo.gif
   ```

PNGs + `demo.gif` are written to `screenshots/` and embedded in `README.md`.

## How it works

- `test_driver/integration_test.dart` - `integrationDriver(onScreenshot:)` writes each PNG to `screenshots/<name>.png`.
- `integration_test/screenshot_test.dart` - initializes Hive and opens the app's boxes in `setUpAll`, pumps the full `HomesteadApp` (go_router + Riverpod), then navigates the app:
  - `01-home` - the multi-species home list (seeded with sample animals Henrietta + Marigold).
  - `02-finance` - taps the wallet app-bar action to open the Finance dashboard (fl_chart line chart + seeded feed/sales entries).
  - `03-savings` - back to home, taps the savings action to open the Homestead Savings goal screen.
  - `04-animal-detail` - back to home, taps the `Henrietta` list tile to open the animal detail screen.
- Each shot calls `binding.convertFlutterSurfaceToImage()` + `pumpAndSettle()` + `binding.takeScreenshot('NN-name')`.
