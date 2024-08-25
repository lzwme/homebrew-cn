cask "utm" do
  version "4.5.4"
  sha256 "1b3c2890afeaf12dfc95b39584680d6aa6c3000af21c9f5e0400161a9b8e40e1"

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