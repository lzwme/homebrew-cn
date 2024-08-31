cask "sonixd" do
  arch arm: "arm64", intel: "x64"

  version "0.15.5"
  sha256 arm:   "3f94302f8ad5a444eea21863c68e4e54305ed1eb15c2789bde92c1daf02baba7",
         intel: "12d5a3f5af551481a4a5ea54bb93b085a4ecd63ff1c3abb3685bf3751030ba2c"

  url "https:github.comjeffvlisonixdreleasesdownloadv#{version}Sonixd-#{version}-mac-#{arch}.dmg"
  name "Sonixd"
  desc "Desktop client for Subsonic-API and Jellyfin music servers"
  homepage "https:github.comjeffvlisonixd"

  deprecate! date: "2024-08-30", because: :discontinued

  app "Sonixd.app"

  zap trash: [
    "~LibraryApplication SupportSonixd",
    "~LibraryCachesorg.erb.sonixd",
    "~LibraryCachesorg.erb.sonixd.ShipIt",
    "~LibraryPreferencesorg.erb.sonixd.plist",
    "~LibrarySaved Application Stateorg.erb.sonixd.savedState",
  ]
end