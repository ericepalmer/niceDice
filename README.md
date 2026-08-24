# Nice Dice

A Mac app for drawing pips from a bag instead of rolling independent six-sided dice.

Each of the five bags holds **six pips**. The number on the bag is how many of those pips are hits (the rest are misses). Clicking a dice cluster under a bag pulls that many pips **without replacement**, then shows hits, misses, and what remains.

That damps the swing of independent dice: two pulls from a 3-bag cannot behave like two separate 3-in-6 coins.

## Run

Open `NiceDice.xcodeproj` in Xcode and run the **Nice Dice** scheme, or:

```sh
xcodebuild -scheme NiceDice -configuration Release -derivedDataPath build
open build/Build/Products/Release/NiceDice.app
```

Requires macOS 14 or later.
