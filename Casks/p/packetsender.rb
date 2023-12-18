cask "packetsender" do
  version "8.5.2"
  sha256 "219a00518f170072564f4faa58064ac15baaffcdf8391b4c13eb9c03692b1296"

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