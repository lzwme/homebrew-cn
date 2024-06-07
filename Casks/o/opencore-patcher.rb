cask "opencore-patcher" do
  version "1.5.0"
  sha256 "15f70a148a5490331a4b9f2b3cb7403b594a049250edd537f95a4b083e9efa9d"

  url "https:github.comdortaniaOpenCore-Legacy-Patcherreleasesdownload#{version}OpenCore-Patcher.pkg",
      verified: "github.comdortaniaOpenCore-Legacy-Patcher"
  name "OpenCore Legacy Patcher"
  desc "Boot loader to injectpatch current features for unsupported Macs"
  homepage "https:dortania.github.ioOpenCore-Legacy-Patcher"

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