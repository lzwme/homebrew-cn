cask "mgba" do
  version "0.10.3"
  sha256 "62969b8b01ac6025424a0c4788ac181d28d340fa60b97f52b336f6e337a14e26"

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