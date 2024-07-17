cask "iina-plus" do
  version "0.8.0"
  sha256 "ddf449adfa802873b99e7f28dfde986b6b06c4a966c7dcc81547bf5f6e18d710"

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