cask "opencore-legacy-patcher" do
  version "2.1.0"
  sha256 "e9239cc40465fb426a6eeab98ac9c214855102dca6f77d3b6b6617b5426d6fb6"

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