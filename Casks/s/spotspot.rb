cask "spotspot" do
  version "4.0.2"
  sha256 "789ea9104c704bf7632ec4d0e06ec614470fe446bbd19076f818136aa05af76f"

  url "https:github.comwill-stoneSpotSpotreleasesdownloadv#{version}SpotSpot-#{version}.dmg",
      verified: "github.comwill-stoneSpotSpot"
  name "SpotSpot"
  desc "Spotify mini-player"
  homepage "https:will-stone.github.ioSpotSpot"

  deprecate! date: "2023-12-17", because: :discontinued

  app "SpotSpot.app"
end