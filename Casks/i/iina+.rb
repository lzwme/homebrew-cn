cask "iina+" do
  version "0.8.3"
  sha256 "b244167488fb59b119c8e04befd66e04d734e4dc58a7b7f1aba96ec325a1bcc2"

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