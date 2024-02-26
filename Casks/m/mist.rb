cask "mist" do
  version "0.10"
  sha256 "9d7f2b1df18fc4f4ce118dabed212ce30f1ff990824535694503ae44c9102319"

  url "https:github.comninxsoftMistreleasesdownloadv#{version}Mist.#{version}.pkg"
  name "Mist"
  desc "Utility that automatically downloads firmwares and installers"
  homepage "https:github.comninxsoftMist"

  auto_updates true
  depends_on macos: ">= :monterey"

  pkg "Mist.#{version}.pkg"

  uninstall launchctl: "com.ninxsoft.mist.helper",
            quit:      [
              "com.ninxsoft.mist",
              "com.ninxsoft.mist.helper",
            ],
            pkgutil:   "com.ninxsoft.pkg.mist",
            delete:    [
              "LibraryLaunchDaemonscom.ninxsoft.mist.helper.plist",
              "LibraryPrivilegedHelperToolscom.ninxsoft.mist.helper",
            ]

  zap trash: [
    "UsersSharedMist",
    "~LibraryCachescom.ninxsoft.mist",
    "~LibraryPreferencescom.ninxsoft.mist.plist",
    "~LibrarySaved Application Statecom.ninxsoft.mist.savedState",
  ]
end