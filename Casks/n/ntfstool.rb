cask "ntfstool" do
  version "2.3.2"
  sha256 "4c8179aebdd171bf1b6ef2d58a4cf89c5f92cab17be68abc4ddfa1ee3b004112"

  url "https:github.comntfstoolntfstoolreleasesdownload#{version}NTFSTool-#{version}.dmg"
  name "NTFSTool"
  desc "Utility that provides NTFS read and write support"
  homepage "https:github.comntfstoolntfstool"

  auto_updates true
  depends_on cask: "macfuse"

  app "NTFSTool.app"

  zap trash: [
    "~LibraryLogsNTFSTool",
    "~LibraryPreferencescom.ntfstool.aile.plist",
  ]
end