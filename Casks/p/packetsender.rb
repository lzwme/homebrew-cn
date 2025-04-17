cask "packetsender" do
  version "8.8.9"
  sha256 "3a18d640b1ed985e3a0b1414f615b615780982cc600e91a81b6dbb577d18f567"

  url "https:github.comdannaglePacketSenderreleasesdownloadv#{version}PacketSender_v#{version}.dmg",
      verified: "github.comdannaglePacketSender"
  name "Packet Sender"
  desc "Network utility for sending  receiving TCP, UDP, SSL"
  homepage "https:packetsender.com"

  livecheck do
    url "https:packetsender.comupdate"
    strategy :json do |json|
      json["macversion"]&.tr("v", "")
    end
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "PacketSender.app"

  zap trash: "~LibraryApplication SupportPacketSender"
end