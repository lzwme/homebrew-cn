cask "mtgaprotracker" do
  version "2.1.35"
  sha256 "f71552a5e97755adf705758c11147ab15b5adb145707daa5ca689da937e3ec40"

  url "https:github.comRazviarmtgapreleasesdownloadv#{version}mtgaprotracker.dmg",
      verified: "github.comRazviarmtgap"
  name "MTGA Pro Tracker"
  desc "Advanced Magic: The Gathering Arena tracking tool"
  homepage "https:mtgarena.promtga-pro-tracker"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-27", because: :discontinued

  app "mtgaprotracker.app"

  zap trash: [
    "~LibraryApplication Supportmtgaprotracker",
    "~LibraryCachescom.mtgarenapro.mtgaprotracker",
    "~LibraryCachescom.mtgarenapro.mtgaprotracker.ShipIt",
    "~LibraryLogsMTGAproTracker",
    "~LibraryPreferencescom.mtgarenapro.mtgaprotracker.plist",
  ]

  caveats do
    requires_rosetta
  end
end