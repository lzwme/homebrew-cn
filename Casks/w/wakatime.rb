cask "wakatime" do
  version "5.16.0"
  sha256 "40d5a1dad1640cce5c10a37451ecec007c81d061b798b9ad19335b096519902f"

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