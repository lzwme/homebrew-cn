cask "syncplay" do
  version "1.7.2"
  sha256 "a8d564d888d3a00a91fd6f17e66ce85bdd70ba2c41a5a04ee290cf799ac38dd8"

  url "https:github.comSyncplaysyncplayreleasesdownloadv#{version}Syncplay_#{version}.dmg",
      verified: "github.comSyncplaysyncplay"
  name "Syncplay"
  desc "Synchronises media players"
  homepage "https:syncplay.pl"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  depends_on macos: ">= :sierra"

  app "Syncplay.app"

  zap trash: [
    "~.syncplay",
    "~LibraryPreferencescom.syncplay.Interface.plist",
    "~LibraryPreferencescom.syncplay.MainWindow.plist",
    "~LibraryPreferencescom.syncplay.MoreSettings.plist",
    "~LibraryPreferencescom.syncplay.PlayerList.plist",
    "~LibraryPreferencespl.syncplay.Syncplay.plist",
    "~LibrarySaved Application Statepl.syncplay.Syncplay.savedState",
  ]
end