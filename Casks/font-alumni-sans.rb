cask "font-alumni-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflalumnisans"
  name "Alumni Sans"
  homepage "https:fonts.google.comspecimenAlumni+Sans"

  font "AlumniSans-Italic[wght].ttf"
  font "AlumniSans[wght].ttf"

  # No zap stanza required
end