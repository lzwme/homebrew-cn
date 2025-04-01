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
    regex(Syncplay[._-]v?(\d+(?:\.\d+)+)\.dmgi)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
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