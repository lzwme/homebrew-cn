cask "opencore-patcher" do
  version "2.4.0"
  sha256 "f84fae9beb5d6a7b2d7a82728c6d79f6c8ab2e5c60efe58c20e4a4882037f80c"

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