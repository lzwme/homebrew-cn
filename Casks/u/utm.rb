cask "utm" do
  version "4.5.3"
  sha256 "ee1a564dee93be7368745b75ad2446a2e81e66e123bd27ae57305615f628e776"

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

  conflicts_with cask: "utm@beta"
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