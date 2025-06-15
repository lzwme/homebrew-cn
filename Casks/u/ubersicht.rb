cask "ubersicht" do
  version "1.6.82"
  sha256 "39db5e0abf03f6390992511c946c19b97a89f84ebe2ac87219ebf921fffb972b"

  url "https:tracesof.netuebersichtreleasesUebersicht-#{version}.app.zip"
  name "Übersicht"
  desc "Run commands and display their output on the desktop"
  homepage "https:tracesof.netuebersicht"

  livecheck do
    url "https:raw.githubusercontent.comfelixhagelohuebersichtgh-pagesupdates.xml.rss"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Übersicht.app"

  uninstall quit:       "tracesOf.Uebersicht",
            login_item: "Übersicht"

  zap trash: [
    "~LibraryApplication SupporttracesOf.Uebersicht",
    "~LibraryApplication SupportÜbersicht",
    "~LibraryCachestracesOf.Uebersicht",
    "~LibraryPreferencestracesOf.Uebersicht.plist",
    "~LibraryWebKittracesOf.Uebersicht",
  ]
end