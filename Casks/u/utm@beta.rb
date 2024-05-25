cask "utm@beta" do
  version "4.5.3"
  sha256 "ee1a564dee93be7368745b75ad2446a2e81e66e123bd27ae57305615f628e776"

  url "https:github.comutmappUTMreleasesdownloadv#{version}UTM.dmg",
      verified: "github.comutmappUTM"
  name "UTM"
  desc "Virtual machines UI using QEMU"
  homepage "https:mac.getutm.app"

  # Use the default livecheck strategy to return the "latest" release
  # regardless of how it is tagged. https:github.comHomebrewhomebrew-cask-versionspull18839#issuecomment-1874765632

  conflicts_with cask: "utm"
  depends_on macos: ">= :big_sur"

  app "UTM.app"
  binary "#{appdir}UTM.appContentsMacOSutmctl"

  uninstall quit: "com.utmapp.UTM"

  zap trash: [
    "~LibraryApplication Scriptscom.utmapp.QEMUHelper",
    "~LibraryApplication Scriptscom.utmapp.UTM",
    "~LibraryContainerscom.utmapp.QEMUHelper",
    "~LibraryContainerscom.utmapp.UTM",
    "~LibraryGroup Containers*.com.utmapp.UTM",
    "~LibraryPreferencescom.utmapp.UTM.plist",
    "~LibrarySaved Application Statecom.utmapp.UTM.savedState",
  ]
end