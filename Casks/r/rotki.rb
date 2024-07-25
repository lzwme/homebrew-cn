cask "rotki" do
  arch arm: "arm64", intel: "x64"

  version "1.34.1"
  sha256 arm:   "f49b540b360773a34cecacbc645d4d88c3ba68a8ec78071c0d27a7ea7cb0ff30",
         intel: "3e2272b099454b25e230e371eafa866e073ede885de4b195c0814ac11b5d2d2d"

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