cask "tencent-lemon" do
  version "5.1.10"
  sha256 "a5d743f6766140e844d70ce9f56364ab0c1f365bbb087583113db4fb27674496"

  url "https:github.comTencentlemon-cleanerreleasesdownloadv#{version}Lemon_#{version}.dmg",
      verified: "github.comTencentlemon-cleaner"
  name "Tencent Lemon Cleaner"
  desc "Cleanup and system status tool"
  homepage "https:lemon.qq.com"

  auto_updates true

  app "Tencent Lemon.app"

  uninstall delete: [
    "LibraryLogsLemon",
    "LibraryPreferencesLemonDaemon_packet.dat",
  ]

  zap trash: [
    "~LibraryCachescom.tencent.Lemon",
    "~LibraryCachescom.tencent.LemonMonitor",
    "~LibraryLogsLemonMonitor.log",
    "~LibraryLogsTencent Lemon.log",
    "~LibraryPreferencescom.tencent.LemonUpdate.plist",
    "~LibraryPreferencesLemonMonitor_packet.dat",
    "~LibraryPreferencesTencent Lemon_packet.dat",
  ]
end