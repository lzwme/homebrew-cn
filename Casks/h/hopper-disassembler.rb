cask "hopper-disassembler" do
  version "6.2.7"
  sha256 "fb2d688bb9d5511a00085c860679a23957a2c4333dc03f882ce0b00de9b7e5f3"

  url "https://www.hopperapp.com/downloader/public/Hopper-#{version}-demo.dmg",
      user_agent: :browser
  name "Hopper Disassembler"
  desc "Reverse engineering tool that lets you disassemble, decompile and debug your app"
  homepage "https://www.hopperapp.com/"

  livecheck do
    url "https://www.hopperapp.com/rss/changelog.xml",
        user_agent: :browser
    regex(/<title>\s*Version\s+v?(\d+(?:\.\d+)+)/i)
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Hopper Disassembler.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.cryptic-apps.hopper-web-4.sfl*",
    "~/Library/Application Support/Hopper Disassembler v4",
    "~/Library/Application Support/Hopper",
    "~/Library/Caches/com.apple.helpd/Generated/com.cryptic-apps.hopper-web-4.help*",
    "~/Library/Caches/com.cryptic-apps.hopper-web-4",
    "~/Library/HTTPStorages/com.cryptic-apps.hopper-web-4",
    "~/Library/Preferences/com.cryptic-apps.hopper-web-4.plist",
    "~/Library/Saved Application State/com.cryptic-apps.hopper-web-4.savedState",
  ]
end