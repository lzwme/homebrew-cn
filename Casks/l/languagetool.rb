cask "languagetool" do
  version "2.2.4"
  sha256 "ff1f5d6b19e6f507120a61ca4df5008c286f16f419e4ca32b977b5f1a58ff313"

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

  depends_on macos: ">= :big_sur"

  app "LanguageTool for Desktop.app"

  uninstall quit: "org.languagetool.desktop"

  zap trash: [
    "~LibraryApplication SupportLanguageTool for Desktop",
    "~LibraryCachesorg.languagetool.desktop",
    "~LibraryPreferencesorg.languagetool.desktop.plist",
  ]
end