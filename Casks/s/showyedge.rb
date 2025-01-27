cask "showyedge" do
  version "6.0.0"
  sha256 "933b78d6398bdbfce42cc1c04d0494e9464f22fb18cbe0951a883f9aa8a8066b"

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