cask "discord" do
  on_catalina :or_older do
    version "0.0.336"
    sha256 "470fc7ad490d7ad42f01632af16dee69fbec6e3db7e3f79af4f2ee246e382398"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur :or_newer do
    version "0.0.354"
    sha256 "26e710e043d648c2802af661a2f8a3f181962e16772219d7a2c91c7b7446d03a"

    livecheck do
      url "https://discord.com/api/download/stable?platform=osx"
      strategy :header_match
    end
  end

  url "https://dl.discordapp.net/apps/osx/#{version}/Discord.dmg",
      verified: "dl.discordapp.net/"
  name "Discord"
  desc "Voice and text chat software"
  homepage "https://discord.com/"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Discord.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.hnc.discord.sfl*",
    "~/Library/Application Support/discord",
    "~/Library/Caches/com.hnc.Discord",
    "~/Library/Caches/com.hnc.Discord.ShipIt",
    "~/Library/Cookies/com.hnc.Discord.binarycookies",
    "~/Library/HTTPStorages/com.hnc.Discord",
    "~/Library/HTTPStorages/com.hnc.Discord.binarycookies",
    "~/Library/Preferences/com.hnc.Discord.helper.plist",
    "~/Library/Preferences/com.hnc.Discord.plist",
    "~/Library/Saved Application State/com.hnc.Discord.savedState",
  ]
end