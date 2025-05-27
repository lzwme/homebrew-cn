cask "packet-peeper" do
  version "2022-08-31"
  sha256 "d930f595ccd391df292c09ae82e3404bf00ed59d8b8f66b462671ee9e1c7c4a2"

  url "https:github.comchollpacketpeeperreleasesdownload#{version}PacketPeeper_#{version}.dmg"
  name "Packet Peeper"
  desc "Network protocol analyzer"
  homepage "https:github.comchollpacketpeeper"

  app "Packet Peeper.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.packetpeeper.sfl*",
    "~LibraryPreferencesorg.PacketPeeper.plist",
    "~LibrarySaved Application Stateorg.PacketPeeper.savedState",
  ]
end