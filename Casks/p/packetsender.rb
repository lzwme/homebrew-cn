cask "packetsender" do
  version "8.10.3"
  sha256 "7dfc914fccfa998b695b9fe0f97040b08557710d79caca94c420d6c32c61f125"

  url "https://ghfast.top/https://github.com/dannagle/PacketSender/releases/download/v#{version}/PacketSender_v#{version}.dmg",
      verified: "github.com/dannagle/PacketSender/"
  name "Packet Sender"
  desc "Network utility for sending / receiving TCP, UDP, SSL"
  homepage "https://packetsender.com/"

  livecheck do
    url "https://packetsender.com/update"
    strategy :json do |json|
      json["macversion"]&.tr("v", "")
    end
  end

  auto_updates true
  depends_on macos: ">= :tahoe"

  app "PacketSender.app"

  zap trash: "~/Library/Application Support/PacketSender"
end