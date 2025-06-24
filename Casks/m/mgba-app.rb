cask "mgba-app" do
  version "0.10.5"
  sha256 "443b490ec728293dfcde1cb9db160f73d94c457cb1864f3ce0407e60e174b09c"

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