cask "ntfstool" do
  version "2.3.2"
  sha256 "4c8179aebdd171bf1b6ef2d58a4cf89c5f92cab17be68abc4ddfa1ee3b004112"

  url "https://ghproxy.com/https://github.com/ntfstool/ntfstool/releases/download/#{version}/NTFSTool-#{version}.dmg"
  name "NTFSTool"
  desc "Utility that provides NTFS read and write support"
  homepage "https://github.com/ntfstool/ntfstool"

  auto_updates true
  depends_on cask: "macfuse"

  app "NTFSTool.app"

  zap trash: [
    "~/Library/Logs/NTFSTool",
    "~/Library/Preferences/com.ntfstool.aile.plist",
  ]
end