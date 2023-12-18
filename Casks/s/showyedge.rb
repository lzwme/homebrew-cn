cask "showyedge" do
  version "5.7.0"
  sha256 "4c91af1254a3e08608d65932ff24bca9983e799c71287a2e3d14b799588f9dc0"

  url "https:github.compqrs-orgShowyEdgereleasesdownloadv#{version}ShowyEdge-#{version}.dmg",
      verified: "github.compqrs-orgShowyEdge"
  name "ShowyEdge"
  desc "Visible indicator of the current input source"
  homepage "https:showyedge.pqrs.org"

  livecheck do
    url "https:appcast.pqrs.orgshowyedge-appcast.xml"
    strategy :sparkle
  end

  depends_on macos: ">= :big_sur"

  app "ShowyEdge.app"

  zap trash: [
    "~LibraryCachesorg.pqrs.ShowyEdge",
    "~LibraryPreferencesorg.pqrs.ShowyEdge.plist",
  ]
end