cask "rotki" do
  version "1.31.1"
  sha256 "08e5498255397465419e113e8b49c0f03f80f12d6447a891991d6f46513f2459"

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