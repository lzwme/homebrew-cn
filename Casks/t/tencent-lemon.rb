cask "tencent-lemon" do
  version "5.1.9"
  sha256 "f97aa97b4a0886be469224fd996d6518763aaacd89d4333af1e16c3ba7bca64a"

  url "https:github.comTencentlemon-cleanerreleasesdownloadv#{version}Lemon.dmg",
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