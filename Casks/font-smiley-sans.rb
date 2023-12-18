cask "font-smiley-sans" do
  version "1.1.1"
  sha256 "17c30d067b90ef6fb259caaf66e4339e30d70d5f197485da8f305c040d41413f"

  url "https:github.comatelier-anchorsmiley-sansreleasesdownloadv#{version}smiley-sans-v#{version}.zip",
      verified: "github.comatelier-anchorsmiley-sans"
  name "Smiley Sans"
  desc "Chinese typeface seeking a visual balance between the humanist and the geometric"
  homepage "https:atelier-anchor.comtypefacessmiley-sans"

  font "SmileySans-Oblique.ttf"

  # No zap stanza required
end