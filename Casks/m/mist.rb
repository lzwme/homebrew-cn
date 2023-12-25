cask "mist" do
  version "0.9.1"
  sha256 "f88c80cbf4f3feb54dbf5fb0d783d6d18e8e039b59b2f87881103fa84677eb8f"

  url "https:github.comninxsoftMistreleasesdownloadv#{version}Mist.#{version}.pkg"
  name "Mist"
  desc "Utility that automatically downloads firmwares and installers"
  homepage "https:github.comninxsoftMist"

  auto_updates true
  depends_on macos: ">= :monterey"

  pkg "Mist.#{version}.pkg"

  uninstall launchctl: "com.ninxsoft.mist.helper",
            quit:      [
              "com.ninxsoft.mist.helper",
              "com.ninxsoft.mist",
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