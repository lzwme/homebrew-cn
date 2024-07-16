cask "mist" do
  version "0.20"
  sha256 "1e78cba40f2b49e015644b0cbd992576054e79bd0a7aa7a8c86b2338f33bc1c3"

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