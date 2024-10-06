cask "mist" do
  version "0.20.1"
  sha256 "45d53266264a3bb6f32656b569ffc3d05df0b7202516df4d320b37f8f0dae6e3"

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