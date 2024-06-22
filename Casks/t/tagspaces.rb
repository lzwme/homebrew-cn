cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "5.8.6"
  sha256 arm:   "0f3ee224c4be686a71629c7a4a40118bea41c4d0390cc62c970b86f74c8be8fd",
         intel: "a77058e8c2922c724c2cfde7a99e2c4072052fb2e2f397fda74b5451f400a8cf"

  url "https:github.comtagspacestagspacesreleasesdownloadv#{version}tagspaces-mac-#{arch}-#{version}.dmg",
      verified: "github.comtagspacestagspaces"
  name "TagSpaces"
  desc "Offline, open-source, document manager with tagging support"
  homepage "https:www.tagspaces.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "TagSpaces.app"

  zap trash: [
    "~LibraryApplication SupportTagSpaces",
    "~LibraryPreferencesorg.tagspaces.desktopapp.plist",
    "~LibrarySaved Application Stateorg.tagspaces.desktopapp.savedState",
  ]
end