cask "spotifree" do
  version "1.6.5"
  sha256 "f518a09187bbf1c033e007fbfbd900222d17c7efd103ef239e61bfdec7caaaec"

  url "https:github.comArtemGordinskySpotifreereleasesdownload#{version}Spotifree.dmg"
  name "Spotifree"
  desc "Automatically mutes ads on Spotify (not supported)"
  homepage "https:github.comArtemGordinskySpotifree"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Spotifree.app"
end