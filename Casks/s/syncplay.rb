cask "syncplay" do
  version "1.7.4"
  sha256 "3933a2011071b736d5acbd68111c1abd19a78135136661201918ea4596ade871"

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