cask "opencore-patcher" do
  version "1.5.0"
  sha256 "1339b694899a0aec51dd32b20f9e7b84df6be08aac56837a94d2bfaf806c155e"

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