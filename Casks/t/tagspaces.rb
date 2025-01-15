cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "6.2.1"
  sha256 arm:   "8ab3f2863088c307db55fdbd68a5f458f115ac714e555a8096734f7e7ff04672",
         intel: "1bde09ca9d86cfac52d7584fcde98ece14031cef16c71648aac94a2066659b66"

  url "https:github.comtagspacestagspacesreleasesdownloadv#{version}tagspaces-mac-#{arch}-#{version}.dmg",
      verified: "github.comtagspacestagspaces"
  name "TagSpaces"
  desc "Offline, open-source, document manager with tagging support"
  homepage "https:www.tagspaces.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "TagSpaces.app"

  zap trash: [
    "~LibraryApplication SupportTagSpaces",
    "~LibraryPreferencesorg.tagspaces.desktopapp.plist",
    "~LibrarySaved Application Stateorg.tagspaces.desktopapp.savedState",
  ]
end