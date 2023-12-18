cask "weakauras-companion" do
  version "5.1.3"
  sha256 "6fb4309dd234b3e5c32417737362cf59d8f4800398e91f2e59281b5668a92281"

  url "https:github.comWeakAurasWeakAuras-Companionreleasesdownloadv#{version}WeakAuras-Companion-#{version}-mac-universal.dmg",
      verified: "github.comWeakAurasWeakAuras-Companion"
  name "WeakAuras Companion"
  desc "Update your auras from Wago.io and creates regular backups of them"
  homepage "https:weakauras.wtf"

  app "WeakAuras Companion.app"

  zap trash: [
    "~LibraryApplication Supportweakauras-companion",
    "~LibraryLogsweakauras-companion",
    "~LibraryPreferenceswtf.weakauras.companion.plist",
  ]
end