cask "opencore-patcher" do
  version "2.1.1"
  sha256 "b4858a9ec4665a3c35d8484f862bf99aee23eaf6c7dd6126e6c3009f5eb0f99a"

  url "https:github.comdortaniaOpenCore-Legacy-Patcherreleasesdownload#{version}OpenCore-Patcher.pkg",
      verified: "github.comdortaniaOpenCore-Legacy-Patcher"
  name "OpenCore Legacy Patcher"
  desc "Boot loader to injectpatch current features for unsupported Macs"
  homepage "https:dortania.github.ioOpenCore-Legacy-Patcher"

  auto_updates true

  pkg "OpenCore-Patcher.pkg"

  uninstall launchctl: [
              "com.dortania.opencore-legacy-patcher.auto-patch",
              "com.dortania.opencore-legacy-patcher.macos-update",
            ],
            pkgutil:   "com.dortania.opencore-legacy-patcher",
            delete:    "ApplicationsOpenCore-Patcher.app"

  zap trash: [
    "LibraryLogsDiagnosticReportsOpenCore-Patcher_*.*_resource.diag",
    "UsersShared.com.dortania.opencore-legacy-patcher.plist",
    "UsersShared.OCLP-AutoPatcher-Log-*.txt",
    "UsersShared.OCLP-System-Log-*.txt",
    "UsersSharedOpenCore-Patcher_*.log",
    "~LibraryApplication SupportCrashReporterOpenCore-Patcher*",
    "~LibraryCachescom.dortania.opencore-legacy-patcher",
    "~LibraryLogsDortania",
    "~LibraryPreferencescom.dortania.opencore-legacy-patcher-wxpython.plist",
    "~LibrarySaved Application Statecom.dortania.opencore-legacy-patcher-wxpython.savedState",
    "~LibrarySaved Application Statecom.dortania.opencore-legacy-patcher.savedState",
    "~LibraryWebKitcom.dortania.opencore-legacy-patcher",
  ]
end