cask "zettelkasten" do
  version "3.2022.8"
  sha256 "62917c18dfd2dd2d8acd7d2ce4db6a4b036fc92a03877da108e85f8c5efcaeea"

  url "https:github.comZettelkasten-TeamZettelkastenreleasesdownloadv#{version}Package.dmg.zip",
      verified: "github.comZettelkasten-TeamZettelkasten"
  name "Zettelkasten"
  desc "Note box according to Luhmann"
  homepage "http:zettelkasten.danielluedecke.de"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "Zettelkasten.app"

  zap trash: [
    "~.Zettelkasten",
    "~LibrarySaved Application Statede.danielluedecke.zettelkasten.ZettelkastenApp.savedState",
  ]

  caveats do
    depends_on_java "8"
  end
end