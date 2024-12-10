cask "mgba" do
  version "0.10.4"
  sha256 "9bd4e7b26ea4cdf26c493aa651ba4f7d93b3cc5a81e8184e98ea3abdf3932023"

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