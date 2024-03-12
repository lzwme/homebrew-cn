cask "mgba" do
  version "0.10.3"
  sha256 "dc9d50b81c5dd032970873e267f347b7b5be5e9e6309f6a28a008cca1b8c007c"

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