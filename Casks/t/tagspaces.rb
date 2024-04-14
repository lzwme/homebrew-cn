cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "5.7.13"
  sha256 arm:   "9c46e45b31241b1b3c9d6039e03d7e6eba997708b4fd6a48c3d6064b8d1b021c",
         intel: "f7e22613b16c06b0212061679235e070405311cdcf2f861be3fd87103e81c7fd"

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