cask "tencent-lemon" do
  version "5.1.12"
  sha256 "ac733a8616d3352aaf52e3d9ab4df039ddd152f3d0f1ea820d421a4c5a06ebfc"

  url "https:github.comTencentlemon-cleanerreleasesdownloadv#{version}Lemon#{version}.dmg",
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