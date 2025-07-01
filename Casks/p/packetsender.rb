cask "packetsender" do
  version "8.9.1"
  sha256 "ffbdbbb7f335fb44788b351f3cf8344b42c0ad8b7dbe5349325fd61e2efa5de9"

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