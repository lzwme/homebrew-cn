cask "jabref" do
  arch arm: "-arm64"

  version "5.14"
  sha256 arm:   "b13a33e95f20b4a6220df748243b6010a7191236bd50aa443becf7bc406e9f76",
         intel: "a0dd346cf774f3c5d20332d11532661ae7d99d58ed51c9871a419cafb74f7d89"

  url "https:github.comJabRefjabrefreleasesdownloadv#{version}JabRef-#{version}#{arch}.dmg",
      verified: "github.comJabRefjabref"
  name "JabRef"
  desc "Reference manager to edit, manage and search BibTeX files"
  homepage "https:www.jabref.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "JabRef.app"

  zap trash: [
    "vardbreceiptsJabRef.bom",
    "vardbreceiptsJabRef.plist",
    "~LibraryApplication SupportJabRef",
    "~LibraryLogsjabref",
    "~LibraryPreferencesorg.jabref.cli.plist",
    "~LibrarySaved Application Stateorg.jabref.cli.savedState",
  ]
end