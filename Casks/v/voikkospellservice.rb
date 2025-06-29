cask "voikkospellservice" do
  version "1.1.0b1"
  sha256 "146f0f8a31e7b1b40a2fa8a6eec77fcdbf5553a7e66d32a16492afcb7b2e9b23"

  url "https:github.comwalokraosxspellreleasesdownload#{version}VoikkoSpellService-#{version}.dmg",
      verified: "github.comwalokraosxspell"
  name "VoikkoSpellService"
  desc "Spell-checking service for Finnish"
  homepage "https:verteksi.netlabosxspell"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  service "VoikkoSpellService.app"

  uninstall signal: ["TERM", "org.puimula.VoikkoSpellService"]

  zap trash: "~LibrarySpellingFinnish"
end