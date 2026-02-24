cask "whatsapp" do
  version "2.26.8.17"
  sha256 "bd68577384501efe80d495f853e9e9ed66b5db50f73baba7d539034bfe702fdb"

  url "https://web.whatsapp.com/desktop/mac_native/release/?version=#{version}&extension=zip&configuration=Release&branch=master&is_buck=true"
  name "WhatsApp"
  desc "Native desktop client for WhatsApp"
  homepage "https://www.whatsapp.com/"

  livecheck do
    url "https://web.whatsapp.com/desktop/mac_native/updates/?branch=master&configuration=Release"
    regex(/version=v?(\d+(?:\.\d+)+)/i)
    strategy :sparkle do |item, regex|
      item.url.scan(regex).map(&:first)
    end
  end

  auto_updates true
  conflicts_with cask: "whatsapp@beta"
  depends_on macos: ">= :monterey"

  app "WhatsApp.app"

  zap trash: [
    "~/Library/Application Scripts/net.whatsapp.WhatsApp*",
    "~/Library/Caches/net.whatsapp.WhatsApp",
    "~/Library/Containers/net.whatsapp.WhatsApp*",
    "~/Library/Group Containers/group.com.facebook.family",
    "~/Library/Group Containers/group.net.whatsapp*",
    "~/Library/Saved Application State/net.whatsapp.WhatsApp.savedState",
  ]
end