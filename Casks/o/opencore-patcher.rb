cask "opencore-patcher" do
  version "1.4.2"
  sha256 "bb377c3c1f1341be295288f085097df3e509e2cff70266b7c1a776023796ed65"

  url "https:github.comdortaniaOpenCore-Legacy-Patcherreleasesdownload#{version}OpenCore-Patcher-GUI.app.zip",
      verified: "github.comdortaniaOpenCore-Legacy-Patcher"
  name "OpenCore Legacy Patcher GUI"
  desc "Boot loader to injectpatch current features for unsupported Macs"
  homepage "https:dortania.github.ioOpenCore-Legacy-Patcher"

  app "OpenCore-Patcher.app"

  uninstall delete: "LibraryLaunchAgentscom.dortania.opencore-legacy-patcher.auto-patch.plist"

  zap trash: [
    "UsersShared.com.dortania.opencore-legacy-patcher.plist",
    "~LibraryApplication SupportCrashReporterOpenCore-Patcher*",
    "~LibraryPreferencescom.dortania.opencore-legacy-patcher-wxpython.plist",
    "~LibrarySaved Application Statecom.dortania.opencore-legacy-patcher-wxpython.savedState",
    "~LibrarySaved Application Statecom.dortania.opencore-legacy-patcher.savedState",
  ]
end