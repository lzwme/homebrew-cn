cask "miaoyan" do
  version "3.4.0"
  sha256 "043d525f858442e521750dd5acf42414a4636fbf099c7a71e3512b99e294ca3b"

  url "https://ghfast.top/https://github.com/tw93/MiaoYan/releases/download/V#{version}/MiaoYan_V#{version}.zip",
      verified: "github.com/tw93/MiaoYan/"
  name "MiaoYan"
  desc "Markdown editor"
  homepage "https://miaoyan.app/"

  livecheck do
    url "https://miaoyan.app/appcast.xml"
    strategy :sparkle do |items|
      items.map(&:nice_version)
    end
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "MiaoYan.app"

  zap trash: [
    "~/Library/Application Support/com.tw93.MiaoYan",
    "~/Library/Caches/com.tw93.MiaoYan",
    "~/Library/HTTPStorages/com.tw93.MiaoYan",
    "~/Library/Preferences/com.tw93.MiaoYan.plist",
  ]
end