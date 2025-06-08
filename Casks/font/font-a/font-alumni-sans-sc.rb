cask "font-alumni-sans-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflalumnisanssc"
  name "Alumni Sans SC"
  homepage "https:fonts.google.comspecimenAlumni+Sans+SC"

  font "AlumniSansSC-Italic[wght].ttf"
  font "AlumniSansSC[wght].ttf"

  # No zap stanza required
end