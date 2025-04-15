cask "tencent-lemon" do
  version "5.1.13"
  sha256 "58658edb843854891cdb944f44b75bcc99ed3a5437de7b93fd231e8bfb27a366"

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