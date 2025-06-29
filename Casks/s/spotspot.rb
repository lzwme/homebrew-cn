cask "spotspot" do
  version "4.0.2"
  sha256 "789ea9104c704bf7632ec4d0e06ec614470fe446bbd19076f818136aa05af76f"

  url "https:github.comwill-stoneSpotSpotreleasesdownloadv#{version}SpotSpot-#{version}.dmg",
      verified: "github.comwill-stoneSpotSpot"
  name "SpotSpot"
  desc "Spotify mini-player"
  homepage "https:will-stone.github.ioSpotSpot"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "SpotSpot.app"
end