cask "utm" do
  version "4.5.2"
  sha256 "a41466b475e7c3d06815e6820a8924e61ba50a1744165f5d10d6cbf33cd7333b"

  url "https:github.comutmappUTMreleasesdownloadv#{version}UTM.dmg",
      verified: "github.comutmappUTM"
  name "UTM"
  desc "Virtual machines UI using QEMU"
  homepage "https:mac.getutm.app"

  livecheck do
    url :url
    regex(v?(\d+(?:[.-]\d+)+)i)
    strategy :github_latest
  end

  conflicts_with cask: "homebrewcask-versionsutm-beta"
  depends_on macos: ">= :big_sur"

  app "UTM.app"
  binary "#{appdir}UTM.appContentsMacOSutmctl"

  uninstall quit: "com.utmapp.UTM"

  zap trash: [
    "~LibraryApplication Scripts*com.utmapp*",
    "~LibraryContainerscom.utmapp*",
    "~LibraryGroup Containers*.com.utmapp.UTM",
    "~LibraryPreferencescom.utmapp.UTM.plist",
    "~LibrarySaved Application Statecom.utmapp.UTM.savedState",
  ]
end