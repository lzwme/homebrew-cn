cask "iina-plus" do
  version "0.7.22"
  sha256 "b3b084f60ee595508e2f04f81e254e31db21996739b0ea45a1e7ba0fdd468f9c"

  url "https:github.comxjbetaiina-plusreleasesdownload#{version}IINA+.#{version}.dmg"
  name "IINA+"
  desc "Extra danmaku support for iina (iina 弹幕支持)"
  homepage "https:github.comxjbetaiina-plus"

  auto_updates true
  depends_on macos: ">= :mojave"

  app "iina+.app"

  zap trash: [
    "~LibraryApplication Supportcom.xjbeta.iina-plus",
    "~LibraryCachescom.xjbeta.iina-plus",
    "~LibraryPreferencescom.xjbeta.iina-plus.plist",
    "~LibraryWebKitcom.xjbeta.iina-plus",
  ]
end