cask "iina+" do
  version "0.8.6"
  sha256 "00314a5cdcb4e4f35233d2395539bd6bd4d9af2f07f2cfbbbd3f6e3314bd91ad"

  url "https:github.comxjbetaiina-plusreleasesdownload#{version}IINA+.#{version}.dmg"
  name "IINA+"
  desc "Extra danmaku support for iina (iina 弹幕支持)"
  homepage "https:github.comxjbetaiina-plus"

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "iina+.app"

  zap trash: [
    "~LibraryApplication Supportcom.xjbeta.iina-plus",
    "~LibraryCachescom.xjbeta.iina-plus",
    "~LibraryPreferencescom.xjbeta.iina-plus.plist",
    "~LibraryWebKitcom.xjbeta.iina-plus",
  ]
end