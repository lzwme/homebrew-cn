cask "shifty" do
  version "1.2"
  sha256 "111b1df97cf5cbca91f4130e6d68d409dbefeffa9fde5f5c92f30f712a7215e9"

  url "https:github.comthompsonateShiftyreleasesdownloadv#{version}Shifty-#{version}.zip",
      verified: "github.comthompsonateShifty"
  name "Shifty"
  desc "Menu bar app that provides more control over Night Shift"
  homepage "https:shifty.natethompson.io"

  livecheck do
    url "https:shifty.natethompson.ioShiftyAppcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "Shifty.app"

  uninstall launchctl: "io.natethompson.ShiftyHelper",
            quit:      "io.natethompson.Shifty"

  zap trash: [
    "~LibraryApplication Scriptsio.natethompson.ShiftyHelper",
    "~LibraryApplication Supportio.natethompson.Shifty",
    "~LibraryCachescom.crashlytics.dataio.natethompson.Shifty",
    "~LibraryCachesio.fabric.sdk.mac.dataio.natethompson.Shifty",
    "~LibraryCachesio.natethompson.Shifty",
    "~LibraryContainersio.natethompson.ShiftyHelper",
    "~LibraryPreferencesio.natethompson.Shifty.plist",
  ]
end