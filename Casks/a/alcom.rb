cask "alcom" do
  version "0.1.16"
  sha256 "751e59a3dbd7ef0f0afefdc72eb16b47644a47f74e8d2b20cf6bc354c9764f6a"

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