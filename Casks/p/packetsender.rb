cask "packetsender" do
  version "8.6.5"
  sha256 "72acd6b351e67d3aa60237f8b3e2253ea1918d529c2a15cf910c3a14fa27e4e4"

  url "https:github.comdannaglePacketSenderreleasesdownloadv#{version}PacketSender_v#{version}.dmg",
      verified: "github.comdannaglePacketSender"
  name "Packet Sender"
  desc "Network utility for sending  receiving TCP, UDP, SSL"
  homepage "https:packetsender.com"

  auto_updates true
  depends_on macos: ">= :sierra"

  app "PacketSender.app"

  zap trash: "~LibraryApplication SupportPacketSender"
end