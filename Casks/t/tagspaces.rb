cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "5.9.1"
  sha256 arm:   "cd0783d9cac4e4d8178bfd51c538f7a59d8dd9db0e169f812107d04290b8f073",
         intel: "6bd1fbf4a33f0925bd042ea28f59c2c61339a30b008a1bf054358f77535d4fa6"

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