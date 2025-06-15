cask "jabref" do
  arch arm: "-arm64"

  version "5.15"
  sha256 arm:   "c4637b9bbfa075c9e25636203e0fda73bbf8ef0166ca35866dbdd13d9f589430",
         intel: "d668ef907b02dfb1941deef5b2896e6bfa343e7ef1aa776effdf248536ae4f99"

  url "https:github.comJabRefjabrefreleasesdownloadv#{version}JabRef-#{version}#{arch}.dmg",
      verified: "github.comJabRefjabref"
  name "JabRef"
  desc "Reference manager to edit, manage and search BibTeX files"
  homepage "https:www.jabref.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

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