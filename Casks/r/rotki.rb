cask "rotki" do
  arch arm: "arm64", intel: "x64"

  version "1.37.0"
  sha256 arm:   "df4743758648720df52fd76973b2ade6c2bc7774d07bbf098595a1005002c26a",
         intel: "6d03f908cf9d3f61b83e1f0b839eb161ba9ff5f5ddf7f6c3e0d9ffa9dff6a9d8"

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