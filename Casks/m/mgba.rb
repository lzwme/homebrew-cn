cask "mgba" do
  version "0.10.2"
  sha256 "c8971fe387b5fcbc3aa9a4f5aaf514290a658b483b5e97f82cad198f9142fd38"

  url "https:github.commgba-emumgbareleasesdownload#{version}mGBA-#{version}-macos.dmg",
      verified: "github.commgba-emumgba"
  name "mGBA"
  desc "Game Boy Advance emulator"
  homepage "https:mgba.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "mGBA.app"

  zap trash: [
    "~LibraryPreferencescom.endrift.mgba-qt.plist",
    "~LibrarySaved Application Statecom.endrift.mgba-qt.savedState",
  ]
end