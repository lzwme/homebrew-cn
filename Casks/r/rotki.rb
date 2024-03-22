cask "rotki" do
  arch arm: "arm64", intel: "x64"

  version "1.32.2"
  sha256 arm:   "ef378cb6703ecde86bbfdd3f485e75aa396248fc806ef08214074098e28867ba",
         intel: "c4c0ad9b2eda72586e21289dd3e2909255fe656b5c20042b011608ac06f8c654"

  url "https:github.comrotkirotkireleasesdownloadv#{version}rotki-darwin_#{arch}-v#{version}.dmg",
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