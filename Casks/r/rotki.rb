cask "rotki" do
  arch arm: "arm64", intel: "x64"

  version "1.35.0"
  sha256 arm:   "7370f3e48b5220ca422716bde10240dbb65d291bd2c8fec275bfa507f69266cf",
         intel: "bd23d9c3bb9e18f3e2828952a593b6c5bca463e9dc387a6fd5a539cf21ef3264"

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