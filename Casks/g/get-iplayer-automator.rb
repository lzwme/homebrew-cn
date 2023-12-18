cask "get-iplayer-automator" do
  version "1.25.4,20230609001"
  sha256 "aeccc377fb5e1bb2ed9384fd3947eb9294bddfa6b92865bee2b68183e558c80f"

  url "https:github.comAscowareget-iplayer-automatorreleasesdownloadv#{version.csv.first}Get.iPlayer.Automator.v#{version.csv.first}.b#{version.csv.second}.zip"
  name "Get iPlayer Automator"
  desc "Download and watch BBC and ITV shows"
  homepage "https:github.comAscowareget-iplayer-automator"

  livecheck do
    url :url
    regex(^Get\.?iPlayer\.?Automator\.?v?(\d+(?:.\d+)*)\.b(\d+)\.zip$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  app "Get iPlayer Automator.app"

  zap trash: [
    "~LibraryApplication SupportGet iPlayer Automator",
    "~LibraryCachescom.ascoware.getiPlayerAutomator",
    "~LibraryHTTPStoragescom.ascoware.getiPlayerAutomator",
    "~LibraryLogsGet iPlayer Automator",
    "~LibraryPreferencescom.ascoware.getiPlayerAutomator.plist",
    "~LibrarySaved Application Statecom.ascoware.getiPlayerAutomator.savedState",
    "~LibraryWebKitcom.ascoware.getiPlayerAutomator",
  ]
end