cask "languagetool" do
  version "2.2.19"
  sha256 "a889b137c6736e891dcfef1be5d900e173227a12d07c9d0de86cfbca8f12631b"

  url "https:languagetool.orgdownloadmac-appLanguageToolDesktop-#{version}.dmg"
  name "LanguageTool for Desktop"
  desc "Grammar, spelling and style suggestions in all the writing apps"
  homepage "https:languagetool.org"

  # Older items in the Sparkle feed may have a newer pubDate, so it's necessary
  # to work with all of the items in the feed (not just the newest one).
  livecheck do
    url "https:languagetool.orgdownloadmac-appappcast.xml"
    regex((\d+(?:\.\d+)+)i)
    strategy :sparkle do |items, regex|
      # The Sparkle versioning scheme is inconsistent. We check the short
      # version directly since the versions are not listed chronologically.
      # The livecheck may need to be reverted to extracting the version from
      # the url. See: https:github.comHomebrewhomebrew-caskpull156995
      items.map { |item| item.short_version[regex, 1] }
    end
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "LanguageTool for Desktop.app"

  uninstall quit: "org.languagetool.desktop"

  zap trash: [
    "~LibraryApplication SupportLanguageTool for Desktop",
    "~LibraryCachesorg.languagetool.desktop",
    "~LibraryPreferencesorg.languagetool.desktop.plist",
  ]
end