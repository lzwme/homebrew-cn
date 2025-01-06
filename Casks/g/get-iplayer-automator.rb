cask "get-iplayer-automator" do
  version "1.26.1,20240329001"
  sha256 "02aa183f6174c5b24f0860c849b3b846e0ba67505eecb8ab58edad81268a5704"

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

  depends_on macos: ">= :high_sierra"

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