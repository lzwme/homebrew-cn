cask "scroll" do
  version "2.10"
  sha256 "dfafa7a0ea40fcbb1ccf532e04835f3e3be4949c89e78ca31ccd8cd1f7c3d33e"

  url "https://ryanhanson.dev/scroll/downloads/Scroll#{version}.dmg"
  name "Scroll"
  desc "Configure scrolling on Trackpad and Magic Mouse"
  homepage "https://ryanhanson.dev/scroll"

  livecheck do
    url "https://ryanhanson.dev/scroll/downloads/updates.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Scroll.app"

  uninstall quit: "com.knollsoft.Scroll"

  zap trash: [
    "~/Library/Application Support/Scroll",
    "~/Library/Caches/com.knollsoft.Scroll",
    "~/Library/Cookies/com.knollsoft.Scroll.binarycookies",
    "~/Library/HTTPStorages/com.knollsoft.Scroll",
    "~/Library/HTTPStorages/com.knollsoft.Scroll.binarycookies",
    "~/Library/Preferences/com.knollsoft.Scroll.plist",
  ]
end