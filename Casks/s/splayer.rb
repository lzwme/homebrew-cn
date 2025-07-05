cask "splayer" do
  version "4.9.4"
  sha256 "e91c8d39840039393d73a682e14ed5115dfa6f66ac582aeee482597525704fe5"

  url "https://ghfast.top/https://github.com/chiflix/splayerx/releases/download/#{version}/SPlayer-#{version}.dmg",
      verified: "github.com/chiflix/splayerx/"
  name "SPlayer"
  desc "Media player"
  homepage "https://splayer.org/"

  no_autobump! because: :requires_manual_review

  app "SPlayer.app"

  caveats do
    requires_rosetta
  end
end