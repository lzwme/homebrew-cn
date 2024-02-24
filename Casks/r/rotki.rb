cask "rotki" do
  version "1.32.1"
  sha256 "737d0f454785a2029c02417b82a036c6051c37cfa4763b23383290c6a7fd102d"

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