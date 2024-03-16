cask "rotki" do
  version "1.32.2"
  sha256 "c4c0ad9b2eda72586e21289dd3e2909255fe656b5c20042b011608ac06f8c654"

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