cask "font-smiley-sans" do
  version "2.0.1"
  sha256 "299c0be6c960ae37361762eca76f7d0cd516615435bb96c0d4b98a1e70178a07"

  url "https:github.comatelier-anchorsmiley-sansreleasesdownloadv#{version}smiley-sans-v#{version}.zip",
      verified: "github.comatelier-anchorsmiley-sans"
  name "Smiley Sans"
  homepage "https:atelier-anchor.comtypefacessmiley-sans"

  no_autobump! because: :requires_manual_review

  font "SmileySans-Oblique.ttf"

  # No zap stanza required
end