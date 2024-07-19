cask "alcom" do
  version "0.1.11"
  sha256 "0c84cf778db3b6bdcc1120ed527cd3af6d9317b0d4e7188d579887008c266d52"

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