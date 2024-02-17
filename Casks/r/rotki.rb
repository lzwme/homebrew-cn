cask "rotki" do
  version "1.32.0"
  sha256 "eade0ef64a43b369b6c06174c1eeb8b75cabb9585b02f67c4a48813e767797a8"

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