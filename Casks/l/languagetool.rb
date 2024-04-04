cask "languagetool" do
  version "1.6.17"
  sha256 "5f70488d82311a3bd0adadea26e0f505fb9d24b74fdbd2dd4dcec39d61042654"

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