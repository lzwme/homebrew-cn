cask "opencore-legacy-patcher" do
  version "2.0.1"
  sha256 "d222669fb4fc3a08526647764873d52f2e854ac2894ff77a134c548a6a7e010f"

  url "https:github.comdortaniaOpenCore-Legacy-Patcherreleasesdownload#{version}OpenCore-Patcher.pkg",
      verified: "github.comdortaniaOpenCore-Legacy-Patcher"
  name "OpenCore Legacy Patcher"
  desc "Patcher to run Big Sur and later (11.x-14.x) on unsupported Macs"
  homepage "https:dortania.github.ioOpenCore-Legacy-Patcher"

  pkg "OpenCore-Patcher.pkg"

  uninstall launchctl: [
              "com.dortania.opencore-legacy-patcher.auto-patch",
              "com.dortania.opencore-legacy-patcher.macos-update",
              "com.dortania.opencore-legacy-patcher.rsr-monitor",
            ],
            pkgutil:   "com.dortania.opencore-legacy-patcher",
            delete:    [
              "ApplicationsOpenCore-Patcher.app",
              "LibraryApplication SupportDortania",
            ]
end