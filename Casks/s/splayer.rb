cask "splayer" do
  version "4.9.4"
  sha256 "e91c8d39840039393d73a682e14ed5115dfa6f66ac582aeee482597525704fe5"

  url "https:github.comchiflixsplayerxreleasesdownload#{version}SPlayer-#{version}.dmg",
      verified: "github.comchiflixsplayerx"
  name "SPlayer"
  desc "Media player"
  homepage "https:splayer.org"

  app "SPlayer.app"

  caveats do
    requires_rosetta
  end
end