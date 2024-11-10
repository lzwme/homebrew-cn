cask "waterfox-classic" do
  version "2022.11"
  sha256 "507151508846e9ea09e695322b9d70ca48dc23d120ab9ac75b899596c1863ff2"

  url "https:github.comWaterfoxCoWaterfox-Classicreleasesdownload#{version}-classicWaterfox.Classic.#{version}.Setup.dmg",
      verified: "github.comWaterfoxCoWaterfox-Classic"
  name "Waterfox Classic"
  desc "Web browser"
  homepage "https:classic.waterfox.net"

  deprecate! date: "2024-11-09", because: :unmaintained

  app "Waterfox Classic.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.mozilla.waterfox.sfl*",
    "~LibraryApplication SupportWaterfox",
    "~LibraryCachesWaterfox",
    "~LibraryPreferencesorg.waterfoxproject.waterfox.plist",
  ]

  caveats do
    requires_rosetta
  end
end