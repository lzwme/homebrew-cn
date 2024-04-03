cask "jabref" do
  arch arm: "-arm64"

  version "5.13"
  sha256 arm:   "4487b119781fcdc9559878280f54c8684062be746abbb9b95b54473a3fea3b1a",
         intel: "65f5fab28437af86b6105a43324c73e4530affca7f21b0487667aa161c7e126d"

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