cask "opencore-patcher" do
  version "1.3.0"
  sha256 "daaa2655f8094dec5068da258d580a2414193c1789d0ae75662dc4937073bd8c"

  url "https:github.comdortaniaOpenCore-Legacy-Patcherreleasesdownload#{version}OpenCore-Patcher-GUI.app.zip",
      verified: "github.comdortaniaOpenCore-Legacy-Patcher"
  name "OpenCore Legacy Patcher GUI"
  desc "Boot loader to injectpatch current features for unsupported Macs"
  homepage "https:dortania.github.ioOpenCore-Legacy-Patcher"

  app "OpenCore-Patcher.app"

  uninstall delete: "LibraryLaunchAgentscom.dortania.opencore-legacy-patcher.auto-patch.plist"

  zap trash: [
    "~LibraryApplication SupportCrashReporterOpenCore-Patcher*",
    "~LibraryPreferencescom.dortania.opencore-legacy-patcher-wxpython.plist",
    "~LibrarySaved Application Statecom.dortania.opencore-legacy-patcher-wxpython.savedState",
    "~LibrarySaved Application Statecom.dortania.opencore-legacy-patcher.savedState",
    "UsersShared.com.dortania.opencore-legacy-patcher.plist",
  ]
end