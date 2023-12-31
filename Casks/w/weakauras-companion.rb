cask "weakauras-companion" do
  version "5.2.1"
  sha256 "7e608977bfb1742767ea086e08857abc05880e5fdf6129a4159c21ae7d035ce1"

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