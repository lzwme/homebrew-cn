cask "jabref" do
  arch arm: "-arm64"

  version "5.12"
  sha256 arm:   "fa4123285e421181c8614ec56d465594774e66ced10b7e77f0a1f147cb7e1885",
         intel: "3081a37479d2b3bec8823e7bd349fe542e5ffb4723f04a967b2597a0decbe898"

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