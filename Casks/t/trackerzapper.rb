cask "trackerzapper" do
  version "1.2.1"
  sha256 "a98920ad628c9f26cfef965a10837f656700f181f250f026c1367d5ebdd7ec45"

  url "https:github.comrknightukTrackerZapperreleasesdownload#{version}TrackerZapper.app.zip",
      verified: "github.comrknightukTrackerZapper"
  name "trackerzapper"
  desc "Menubar app to remove link tracking parameters automatically"
  homepage "https:rknight.meappstracker-zapper"

  depends_on macos: ">= :big_sur"

  app "TrackerZapper.app"

  uninstall quit: "com.rknightuk.TrackerZapper"

  zap trash: [
    "~LibraryApplication Scriptscom.rknightuk.TrackerZapper",
    "~LibraryApplication Scriptscom.rknightuk.TrackerZapper-LaunchAtLoginHelper",
    "~LibraryContainerscom.rknightuk.TrackerZapper",
    "~LibraryContainerscom.rknightuk.TrackerZapper-LaunchAtLoginHelper",
  ]
end