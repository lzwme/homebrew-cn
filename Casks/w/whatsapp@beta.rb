cask "whatsapp@beta" do
  version "2.25.21.35"
  sha256 "40a2c488d3ab7ea7a0361843cc28b8bdac2d328d7743023517a0c85f16e4ad52"

  url "https://web.whatsapp.com/desktop/mac_native/release/?version=#{version}&extension=zip&configuration=Beta&branch=master"
  name "WhatsApp Beta"
  desc "Native desktop client for WhatsApp"
  homepage "https://www.whatsapp.com/"

  livecheck do
    url "https://web.whatsapp.com/desktop/mac_native/updates/?configuration=Beta&branch=master"
    regex(/version=v?(\d+(?:\.\d+)+)/i)
    strategy :sparkle do |item, regex|
      item.url.scan(regex).map(&:first)
    end
  end

  auto_updates true
  conflicts_with cask: [
    "whatsapp",
    "whatsapp@legacy",
  ]
  depends_on macos: ">= :monterey"

  app "WhatsApp.app"

  zap trash: [
    "~/Library/Application Scripts/net.whatsapp.WhatsApp",
    "~/Library/Application Scripts/net.whatsapp.WhatsApp.Intents",
    "~/Library/Application Scripts/net.whatsapp.WhatsApp.IntentsUI",
    "~/Library/Application Scripts/net.whatsapp.WhatsApp.ServiceExtension",
    "~/Library/Caches/net.whatsapp.WhatsApp",
    "~/Library/Containers/net.whatsapp.WhatsApp",
    "~/Library/Containers/net.whatsapp.WhatsApp.Intents",
    "~/Library/Containers/net.whatsapp.WhatsApp.ServiceExtension",
    "~/Library/Group Containers/group.com.facebook.family",
    "~/Library/Group Containers/group.net.whatsapp.family",
    "~/Library/Group Containers/group.net.whatsapp.WhatsApp.private",
    "~/Library/Group Containers/group.net.whatsapp.WhatsApp.shared",
    "~/Library/Group Containers/group.net.whatsapp.WhatsAppSMB.shared",
    "~/Library/Saved Application State/net.whatsapp.WhatsApp.savedState",
  ]
end