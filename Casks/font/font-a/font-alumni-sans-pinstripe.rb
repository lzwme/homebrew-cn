cask "font-alumni-sans-pinstripe" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflalumnisanspinstripe"
  name "Alumni Sans Pinstripe"
  homepage "https:fonts.google.comspecimenAlumni+Sans+Pinstripe"

  font "AlumniSansPinstripe-Italic.ttf"
  font "AlumniSansPinstripe-Regular.ttf"

  # No zap stanza required
end