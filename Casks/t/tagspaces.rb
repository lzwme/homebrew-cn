cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "6.4.8"
  sha256 arm:   "bb896806761da4d198a821468a888d53c242571729d82cb19cf0759b99b0ffd0",
         intel: "331390094822e87ae13b2c54f456462bef4eb6ccdd8e22546e05078312582e01"

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