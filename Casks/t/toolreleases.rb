cask "toolreleases" do
  version "1.5.0,59"
  sha256 "2097bafa9cfe648c259e5c81f98137e3e38217838deccfe262460773807dd8df"

  url "https:github.comDeveloperMarisToolReleasesreleasesdownloadv#{version.csv.first}ToolReleases_v#{version.csv.first}.b#{version.csv.second}.zip"
  name "ToolReleases"
  desc "Utility to notify about the latest Apple tool releases (including Beta releases)"
  homepage "https:github.comDeveloperMarisToolReleases"

  livecheck do
    url "https:developermaris.github.ioToolReleasesappcast_v2.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "ToolReleases.app"

  uninstall quit:       [
              "com.apple.systemevents",
              "com.developermaris.ToolReleases",
            ],
            login_item: "ToolReleases"

  zap trash: [
    "~LibraryCachescom.developermaris.ToolReleases",
    "~LibraryPreferencescom.developermaris.ToolReleases.plist",
  ]
end