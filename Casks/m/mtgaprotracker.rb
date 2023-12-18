cask "mtgaprotracker" do
  version "2.1.35"
  sha256 "f71552a5e97755adf705758c11147ab15b5adb145707daa5ca689da937e3ec40"

  url "https:github.comRazviarmtgapreleasesdownloadv#{version}mtgaprotracker.dmg",
      verified: "github.comRazviarmtgap"
  name "MTGA Pro Tracker"
  desc "Advanced Magic: The Gathering Arena tracking tool"
  homepage "https:mtgarena.promtga-pro-tracker"

  # GitHub releases don't regularly provide a file for macOS. We check the link
  # to the latest Mac version from the README, as it's unlikely for there to be
  # a release with a macOS file in the recent releases.
  livecheck do
    url "https:raw.githubusercontent.comRazviarmtgapmasterREADME.md"
    regex(Mac(?:OS)?\s+version.*?v?(\d+(?:\.\d+)+)i)
  end

  app "mtgaprotracker.app"

  zap trash: [
    "~LibraryApplication Supportmtgaprotracker",
    "~LibraryCachescom.mtgarenapro.mtgaprotracker",
    "~LibraryCachescom.mtgarenapro.mtgaprotracker.ShipIt",
    "~LibraryLogsMTGAproTracker",
    "~LibraryPreferencescom.mtgarenapro.mtgaprotracker.plist",
  ]
end