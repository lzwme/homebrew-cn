cask "miaoyan" do
  version "1.14.0"
  sha256 "bb9d61c8551b7dd40dbe55896f86c9dff64dfa57dcaff8442701ed1c8f700249"

  url "https:github.comtw93MiaoYanreleasesdownloadV#{version}MiaoYan.dmg",
      verified: "github.comtw93MiaoYan"
  name "MiaoYan"
  desc "Markdown editor"
  homepage "https:miaoyan.app"

  app "MiaoYan.app"

  zap trash: [
    "~LibraryApplication Supportcom.tw93.MiaoYan",
    "~LibraryCachescom.tw93.MiaoYan",
    "~LibraryHTTPStoragescom.tw93.MiaoYan",
    "~LibraryPreferencescom.tw93.MiaoYan.plist",
  ]
end