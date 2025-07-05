cask "spotspot" do
  version "4.0.2"
  sha256 "789ea9104c704bf7632ec4d0e06ec614470fe446bbd19076f818136aa05af76f"

  url "https://ghfast.top/https://github.com/will-stone/SpotSpot/releases/download/v#{version}/SpotSpot-#{version}.dmg",
      verified: "github.com/will-stone/SpotSpot/"
  name "SpotSpot"
  desc "Spotify mini-player"
  homepage "https://will-stone.github.io/SpotSpot/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "SpotSpot.app"
end