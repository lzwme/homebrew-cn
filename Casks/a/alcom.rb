cask "alcom" do
  version "0.1.7"
  sha256 "3d1f3e9372ae0f3ea141eafbcf8242da6f074eb0c0f14b3b7f6c048cfffa8e44"

  url "https:github.comvrc-getvrc-getreleasesdownloadgui-v#{version}ALCOM-#{version}-universal.dmg"
  name "ALCOM"
  desc "Graphical frontend of vrc-get, open source alternative to VRChat Package Manager"
  homepage "https:github.comvrc-getvrc-get"

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