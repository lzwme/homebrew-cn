cask "syncplay" do
  version "1.7.3"
  sha256 "a656a60c11fcc0f840a461ed38708310a1138e28eb385d0f7167da18996df1b9"

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