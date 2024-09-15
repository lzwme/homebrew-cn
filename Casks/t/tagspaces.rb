cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "6.0.0"
  sha256 arm:   "09d25f577d8c127c47735c9223927ecf3e964027ed42f58b9b7ac895b653d3ce",
         intel: "858e8a52d7b6dbec367cfb5982f6190054550f1937844a473eaa96c598d81e29"

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