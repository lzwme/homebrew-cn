cask "multitouch" do
  version "1.27.21"
  sha256 "52bdc5741c473db91835ccc6a07196beb5be632d60b24c2e19f49968f568ce17"

  url "https://multitouch.app/downloads/multitouch#{version}.dmg"
  name "Multitouch"
  desc "Add more gestures for Trackpad and Magic Mouse"
  homepage "https://multitouch.app/"

  livecheck do
    url "https://multitouch.app/downloads/updates.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Multitouch.app"

  uninstall quit: "com.brassmonkery.Multitouch"

  zap trash: [
    "~/Library/Application Support/Multitouch",
    "~/Library/Caches/com.brassmonkery.Multitouch",
    "~/Library/Cookies/com.brassmonkery.Multitouch.binarycookies",
    "~/Library/HTTPStorages/com.brassmonkery.Multitouch",
    "~/Library/HTTPStorages/com.brassmonkery.Multitouch.binarycookies",
    "~/Library/Preferences/com.brassmonkery.Multitouch.plist",
  ]
end