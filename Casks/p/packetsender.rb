cask "packetsender" do
  version "8.6.3"
  sha256 "f778842269b185893e5ea20ab0453f2400a747560054e3cda92e2a2f687eca1b"

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