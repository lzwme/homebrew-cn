cask "utm" do
  version "4.4.5"
  sha256 "16520f496a98d95d5a91dfc89d2e813c405f73ca68989f238039ecef0bda3a6f"

  url "https:github.comutmappUTMreleasesdownloadv#{version}UTM.dmg",
      verified: "github.comutmappUTM"
  name "UTM"
  desc "Virtual machines UI using QEMU"
  homepage "https:getutm.app"

  livecheck do
    url :url
    regex(v?(\d+(?:[.-]\d+)+)i)
    strategy :github_latest
  end

  conflicts_with cask: "homebrewcask-versionsutm-beta"

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