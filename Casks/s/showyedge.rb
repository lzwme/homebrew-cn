cask "showyedge" do
  version "6.1.0"
  sha256 "59b7571eddca8fd8e619afd8c002be280fbbdcf2a2830de311c8951fca56d435"

  url "https:github.compqrs-orgShowyEdgereleasesdownloadv#{version}ShowyEdge-#{version}.dmg",
      verified: "github.compqrs-orgShowyEdge"
  name "ShowyEdge"
  desc "Visible indicator of the current input source"
  homepage "https:showyedge.pqrs.org"

  livecheck do
    url "https:appcast.pqrs.orgshowyedge-appcast.xml"
    strategy :sparkle
  end

  depends_on macos: ">= :ventura"

  app "ShowyEdge.app"

  zap trash: [
    "~LibraryCachesorg.pqrs.ShowyEdge",
    "~LibraryPreferencesorg.pqrs.ShowyEdge.plist",
  ]
end