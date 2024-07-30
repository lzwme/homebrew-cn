cask "tencent-lemon" do
  version "5.1.9.1019"
  sha256 "9a2d7525b4ad651cf39afa6d21671a4c3210275d5b46d2f68b0f76a78b3ee43f"

  url "https:github.comTencentlemon-cleanerreleasesdownloadv#{version}Lemon_v#{version}.dmg",
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