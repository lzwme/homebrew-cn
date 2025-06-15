cask "weakauras-companion" do
  version "5.2.10"
  sha256 "acd79515c9a9c66489a17025e79961532b601f6721d5593ea176ac9e2416c913"

  url "https:github.comWeakAurasWeakAuras-Companionreleasesdownloadv#{version}WeakAuras-Companion-#{version}-mac-universal.dmg"
  name "WeakAuras Companion"
  desc "Update your auras from Wago.io and creates regular backups of them"
  homepage "https:github.comWeakAurasWeakAuras-Companion"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "WeakAuras Companion.app"

  zap trash: [
    "~LibraryApplication Supportweakauras-companion",
    "~LibraryLogsweakauras-companion",
    "~LibraryPreferenceswtf.weakauras.companion.plist",
  ]
end