cask "opencore-patcher" do
  version "1.4.1"
  sha256 "d9f1498b46a984c66b8fa38fe185bd4934c03298515e30465902b137e9b35148"

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