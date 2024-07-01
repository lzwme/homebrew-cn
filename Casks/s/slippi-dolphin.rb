cask "slippi-dolphin" do
  version "3.4.0"
  sha256 "bb5eb544055c47ebfee905e3ca7268f276757199fbd32420afc6968fca7ea114"

  url "https:github.comproject-slippiIshiirukareleasesdownloadv#{version}FM-Slippi-#{version}-Mac.dmg",
      verified: "github.comproject-slippiIshiiruka"
  name "Slippi"
  desc "Fork of the Dolphin GameCube and Wii emulator with netplay support via Slippi"
  homepage "https:slippi.gg"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Slippi Dolphin.app"

  zap trash: [
    "~LibraryApplication SupportDolphin",
    "~LibraryPreferencescom.project-slippi.dolphin.plist",
  ]

  caveats do
    requires_rosetta
  end
end