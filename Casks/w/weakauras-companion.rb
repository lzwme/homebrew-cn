cask "weakauras-companion" do
  version "5.2.2"
  sha256 "937991424e8115be9457f091a95f0e2f1193d11f8c8a9bac50225905823e9483"

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