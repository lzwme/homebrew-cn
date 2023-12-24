cask "rotki" do
  version "1.31.2"
  sha256 "f34f8328ae93f33fbc8bcdc86f43c0c2e78f514eb189b1af9029cc72b39464c1"

  url "https:github.comrotkirotkireleasesdownloadv#{version}rotki-darwin_x64-v#{version}.dmg",
      verified: "github.comrotkirotki"
  name "Rotki"
  desc "Portfolio tracking and accounting tool"
  homepage "https:rotki.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "rotki.app"

  zap trash: [
    "~LibraryApplication Supportrotki",
    "~LibraryPreferencescom.rotki.app.plist",
    "~LibrarySaved Application Statecom.rotki.app.savedState",
  ]
end