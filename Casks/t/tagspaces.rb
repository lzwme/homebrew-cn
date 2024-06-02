cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "5.8.3"
  sha256 arm:   "1072c131c4e20a4df5402f6447149f6bd166383409db53e982df9fdafb036145",
         intel: "2db3f3821bca9d20f77ae154bdf269ab81735ec7d2f8b003891bac70c90a2e49"

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