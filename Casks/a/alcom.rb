cask "alcom" do
  version "0.1.13"
  sha256 "b3986db2086cfe7f36972277c333f91b667b8258fcc5be4099913ad1af39cd2b"

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