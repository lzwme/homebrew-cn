cask "syncplay" do
  version "1.7.1"
  sha256 "28a3b505cd611bf655fe0bc99df436bd692af1ed18c081fb6a01a1bf01eb6e25"

  url "https:github.comSyncplaysyncplayreleasesdownloadv#{version}Syncplay_#{version}.dmg",
      verified: "github.comSyncplaysyncplay"
  name "Syncplay"
  desc "Synchronises media players"
  homepage "https:syncplay.pl"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  depends_on macos: ">= :sierra"

  app "Syncplay.app"

  zap trash: [
    "~.syncplay",
    "~LibrarySaved Application Statepl.syncplay.Syncplay.savedState",
    "~LibraryPreferencescom.syncplay.MoreSettings.plist",
    "~LibraryPreferencescom.syncplay.Interface.plist",
    "~LibraryPreferencescom.syncplay.MainWindow.plist",
    "~LibraryPreferencespl.syncplay.Syncplay.plist",
    "~LibraryPreferencescom.syncplay.PlayerList.plist",
  ]
end