cask "opencore-patcher" do
  version "2.3.0"
  sha256 "23eff60daf11234073becc22056b6c80e33e56c9a913f90737da2b523e6beb66"

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