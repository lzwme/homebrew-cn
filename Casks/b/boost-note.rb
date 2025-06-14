cask "boost-note" do
  version "0.23.1"
  sha256 "7495fb235067c6548179a7e6fbaaa728e9616b92e5b5984481d4c97f84996953"

  url "https:github.comBoostIOBoostNote.nextreleasesdownloadv#{version}boost-note-mac.dmg",
      verified: "github.comBoostIOBoostNote.next"
  name "Boostnote.Next"
  desc "Markdown note editor for developers"
  homepage "https:boostnote.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "Boost Note.app"

  uninstall signal: ["TERM", "com.boostio.boostnote"]

  zap trash: [
    "~LibraryApplication SupportBoost Note",
    "~LibraryPreferencescom.boostio.boostnote.plist",
    "~LibrarySaved Application Statecom.boostio.boostnote.savedState",
  ]

  caveats do
    requires_rosetta
  end
end