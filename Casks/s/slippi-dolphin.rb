cask "slippi-dolphin" do
  version "3.4.3"
  sha256 "8e56041b5a6668464406fff6f28fba7a466007fb8195a646de77e3ac7f2ffe64"

  url "https:github.comproject-slippiIshiirukareleasesdownloadv#{version}FM-Slippi-#{version}-Mac.dmg",
      verified: "github.comproject-slippiIshiiruka"
  name "Slippi"
  desc "Fork of the Dolphin GameCube and Wii emulator with netplay support via Slippi"
  homepage "https:slippi.gg"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Slippi Dolphin.app"

  zap trash: [
    "~LibraryApplication SupportDolphin",
    "~LibraryPreferencescom.project-slippi.dolphin.plist",
  ]

  caveats do
    requires_rosetta
  end
end