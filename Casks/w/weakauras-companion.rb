cask "weakauras-companion" do
  version "5.2.7"
  sha256 "77dc9952535c8f2fe4efa1eb62a10a8751cc2846bccce60edf1dcf28854afb34"

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