cask "wakatime" do
  version "5.0.0"
  sha256 "8c59f4c9d5f7c4ca1797b3e4fabc4c03c78e8c7283603de80cfd3941cdd12a37"

  url "https:github.comwakatimemacos-wakatimereleasesdownloadv#{version}macos-wakatime.zip",
      verified: "github.comwakatimemacos-wakatime"
  name "Wakatime"
  desc "System tray app for automatic time tracking"
  homepage "https:wakatime.commac"

  depends_on macos: ">= :catalina"

  app "WakaTime.app"

  zap trash: [
    "~LibraryApplication Supportmacos-wakatime.WakaTime",
    "~LibraryCachesmacos-wakatime.WakaTime",
    "~LibraryHTTPStoragesmacos-wakatime.WakaTime",
    "~LibraryPreferencesmacos-wakatime.WakaTime.plist",
  ]
end