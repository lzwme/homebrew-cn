cask "wechat" do
  version "3.8.7.17"
  sha256 :no_check

  url "https:dldir1.qq.comweixinmacWeChatMac.dmg"
  name "WeChat for Mac"
  name "微信 Mac 版"
  desc "Free messaging and calling application"
  homepage "https:mac.weixin.qq.com"

  # This appcast is slower to update than the submissions we get. See:
  #   https:github.comHomebrewhomebrew-caskpull90907#issuecomment-710107547
  livecheck do
    url "https:dldir1.qq.comweixinmacmac-release.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "WeChat.app"

  uninstall quit: "com.tencent.xinWeChat"

  zap trash: [
    "~LibraryApplication Scripts$(TeamIdentifierPrefix)com.tencent.xinWeChat",
    "~LibraryApplication Scripts$(TeamIdentifierPrefix)com.tencent.xinWeChat.IPCHelper",
    "~LibraryApplication Scriptscom.tencent.xinWeChat",
    "~LibraryApplication Scriptscom.tencent.xinWeChat.MiniProgram",
    "~LibraryApplication Scriptscom.tencent.xinWeChat.WeChatMacShare",
    "~LibraryCachescom.tencent.xinWeChat",
    "~LibraryContainers$(TeamIdentifierPrefix)com.tencent.xinWeChat.IPCHelper",
    "~LibraryContainerscom.tencent.xinWeChat",
    "~LibraryContainerscom.tencent.xinWeChat.MiniProgram",
    "~LibraryContainerscom.tencent.xinWeChat.WeChatMacShare",
    "~LibraryCookiescom.tencent.xinWeChat.binarycookies",
    "~LibraryGroup Containers$(TeamIdentifierPrefix)com.tencent.xinWeChat",
    "~LibraryPreferencescom.tencent.xinWeChat.plist",
    "~LibrarySaved Application Statecom.tencent.xinWeChat.savedState",
  ]
end