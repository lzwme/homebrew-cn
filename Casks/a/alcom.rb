cask "alcom" do
  version "1.1.2"
  sha256 "4b1b1cb23378c81ce4edf0060b8f15a6e4a9a934246dedc4a99266692e12ccd6"

  url "https:github.comvrc-getvrc-getreleasesdownloadgui-v#{version}ALCOM-#{version}-universal.dmg",
      verified: "github.comvrc-getvrc-get"
  name "ALCOM"
  desc "Graphical frontend of vrc-get, open source alternative to VRChat Package Manager"
  homepage "https:vrc-get.anatawa12.comalcom"

  livecheck do
    url :url
    regex(^gui[._-]v?(\d+(?:\.\d+)+)$i)
  end

  depends_on macos: ">= :high_sierra"

  app "ALCOM.app"

  zap trash: [
    "~LibraryCachescom.anataw12.vrc-get",
    "~LibraryPreferencescom.anataw12.vrc-get.plist",
    "~LibrarySaved Application Statecom.anataw12.vrc-get.savedState",
    "~LibraryWebKitcom.anataw12.vrc-get",
    "~LibraryWebKitvrc-get-gui",
  ]
end