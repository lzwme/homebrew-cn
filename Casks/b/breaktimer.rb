cask "breaktimer" do
  version "1.2.0"
  sha256 "feebd9f838df0892664a1377f4e2cd568ffe823132390b82f6592da17d164566"

  url "https:github.comtom-james-watsonbreaktimer-appreleasesdownloadv#{version}BreakTimer.dmg",
      verified: "github.comtom-james-watsonbreaktimer-app"
  name "BreakTimer"
  desc "Tool to manage periodic breaks"
  homepage "https:breaktimer.app"

  auto_updates true

  app "BreakTimer.app"
  binary "#{appdir}BreakTimer.appContentsMacOSBreakTimer", target: "breaktimer"

  uninstall quit:      "com.tomjwatson.breaktimer",
            launchctl: "com.tomjwatson.breaktimer.ShipIt"

  zap trash: [
    "~LibraryApplication SupportBreakTimer",
    "~LibraryCachescom.tomjwatson.breaktimer",
    "~LibraryCachescom.tomjwatson.breaktimer.ShipIt",
    "~LibraryLogsBreakTimer",
    "~LibraryPreferencesByHostcom.tomjwatson.breaktimer.ShipIt.*.plist",
    "~LibraryPreferencescom.tomjwatson.breaktimer.plist",
    "~LibrarySaved Application Statecom.tomjwatson.breaktimer.savedState",
  ]
end