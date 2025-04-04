cask "wakatime" do
  version "5.27.1"
  sha256 "3c20f84056ed640c29724de241ab9023bb6487f18537ae4989f1dfffb67f9364"

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