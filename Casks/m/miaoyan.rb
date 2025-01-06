cask "miaoyan" do
  version "1.15.0"
  sha256 "abc279f16ac3543598320d31cd693e405b78ff92dbcaa21bb2df96301c17b13c"

  url "https:github.comtw93MiaoYanreleasesdownloadV#{version}MiaoYan.dmg",
      verified: "github.comtw93MiaoYan"
  name "MiaoYan"
  desc "Markdown editor"
  homepage "https:miaoyan.app"

  depends_on macos: ">= :catalina"

  app "MiaoYan.app"

  zap trash: [
    "~LibraryApplication Supportcom.tw93.MiaoYan",
    "~LibraryCachescom.tw93.MiaoYan",
    "~LibraryHTTPStoragescom.tw93.MiaoYan",
    "~LibraryPreferencescom.tw93.MiaoYan.plist",
  ]
end