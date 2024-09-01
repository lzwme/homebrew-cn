cask "typcn-bilibili" do
  version "2.56"
  sha256 "62784fa27396644337c5ee63d6e3ad32e3436aed7eb79009a306ef6100527452"

  url "https:github.comtypcnbilibili-mac-clientreleasesdownload#{version}Bilibili.dmg"
  name "Bilibili"
  desc "Unofficial bilibili client"
  homepage "https:github.comtypcnbilibili-mac-client"

  deprecate! date: "2024-08-30", because: :unmaintained

  auto_updates true

  app "Bilibili.app"

  zap trash: [
    "~LibraryApplication Supportcom.crashlyticscom.typcn.bilibili",
    "~LibraryApplication Supportcom.typcn.bilibili",
    "~LibraryWebKitcom.typcn.bilibili",
  ]

  caveats do
    requires_rosetta
  end
end