cask "jabref" do
  arch arm: "-arm64"

  version "5.11"
  sha256 arm:   "d53875651ef86c617b0728b20513552c9ce6065b09fefb5e6daa448eaf20976e",
         intel: "71becc574eaf8cfe741a033fd1458d612d18a6f9c5463c837b83b8c0594738c2"

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
    "~LibraryApplication SupportJabRef",
    "~LibraryLogsjabref",
    "~LibraryPreferencesorg.jabref.cli.plist",
    "~LibrarySaved Application Stateorg.jabref.cli.savedState",
    "vardbreceiptsJabRef.bom",
    "vardbreceiptsJabRef.plist",
  ]
end