cask "dingtalk" do
  version "7.6.10_39616146"
  sha256 "e273503c1b772038d509f51ec1031ad2cc11d4c9a6495a309342f6cf421c568f"

  url "https://dtapp-pub.dingtalk.com/dingtalk-desktop/mac_dmg/Release/M1-Beta/DingTalk_v#{version}_universal.dmg"
  name "DingTalk"
  name "钉钉"
  desc "Teamwork app by Alibaba Group"
  homepage "https://www.dingtalk.com/"

  livecheck do
    url "https://im.dingtalk.com/manifest/appcast_gray_release.xml"
    regex(/DingTalk[._-]v?(\d+(?:[._]\d+)+)[._-]universal\.dmg/i)
    strategy :sparkle do |item|
      item.url[regex, 1]
    end
  end

  auto_updates true

  app "DingTalk.app"

  uninstall quit: "com.alibaba.DingTalkMac"

  zap trash: [
    "~/Library/Application Support/DingTalkMac",
    "~/Library/Caches/com.alibaba.DingTalkInstaller",
    "~/Library/Caches/com.alibaba.DingTalkMac",
    "~/Library/Caches/DingTalk",
    "~/Library/Preferences/com.alibaba.DingTalk-Helper.plist",
    "~/Library/Preferences/com.alibaba.DingTalkInstaller.plist",
    "~/Library/Preferences/com.alibaba.DingTalkMac.plist",
    "~/Library/Preferences/com.dingtalk.mac.plist",
    "~/Library/Saved Application State/com.alibaba.DingTalkMac.savedState",
    "~/Library/WebKit/com.alibaba.DingTalkMac",
  ]
end