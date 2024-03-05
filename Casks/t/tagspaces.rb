cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "5.7.8"
  sha256 arm:   "45460449a2ea44984171143a15756f6ad5105fd393930f02c7420469bed20dae",
         intel: "c5f21e865506f9085abdb2116d19dc7f412a2073bc007f794074a594c0a6c1dd"

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