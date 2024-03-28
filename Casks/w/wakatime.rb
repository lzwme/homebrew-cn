cask "wakatime" do
  version "5.14.1"
  sha256 "d1882307a0b35a045743ab59c9372ac90e535c7f7f4fc4d1792142bc14c9180b"

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