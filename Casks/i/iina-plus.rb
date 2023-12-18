cask "iina-plus" do
  version "0.7.16"
  sha256 "8975accf5bc82b7036841c289ad49b886c36a583d913998ab58b9d79d6580320"

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