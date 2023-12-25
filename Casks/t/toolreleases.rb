cask "toolreleases" do
  version "1.5.0,59"
  sha256 "2097bafa9cfe648c259e5c81f98137e3e38217838deccfe262460773807dd8df"

  url "https:github.comDeveloperMarisToolReleasesreleasesdownloadv#{version.csv.first}ToolReleases_v#{version.csv.first}.b#{version.csv.second}.zip"
  name "ToolReleases"
  desc "Utility to notify about the latest Apple tool releases (including Beta releases)"
  homepage "https:github.comDeveloperMarisToolReleases"

  livecheck do
    url :url
    regex(^ToolReleases[._-]v?(\d+(?:\.\d+)+)[._-]b(\d+)\.zip$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "ToolReleases.app"

  uninstall quit:       [
              "com.developermaris.ToolReleases",
              "com.apple.systemevents",
            ],
            login_item: "ToolReleases"

  zap trash: [
    "~LibraryCachescom.developermaris.ToolReleases",
    "~LibraryPreferencescom.developermaris.ToolReleases.plist",
  ]
end