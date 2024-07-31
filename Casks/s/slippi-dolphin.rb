cask "slippi-dolphin" do
  version "3.4.2"
  sha256 "2e696cc442a25f01d9567433d31cda8f99bbafc4dddb1ee80fc160657fabe5a8"

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