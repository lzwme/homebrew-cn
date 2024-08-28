cask "wakatime" do
  version "5.23.1"
  sha256 "8903f4fbe1714eacb56605257c24f5ed22a441c70261cd16c668be0010c7d165"

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