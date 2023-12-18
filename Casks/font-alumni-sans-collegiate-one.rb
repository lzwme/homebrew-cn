cask "font-alumni-sans-collegiate-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflalumnisanscollegiateone"
  name "Alumni Sans Collegiate One"
  desc "Font inspired by Impact Black"
  homepage "https:fonts.google.comspecimenAlumni+Sans+Collegiate+One"

  font "AlumniSansCollegiateOne-Italic.ttf"
  font "AlumniSansCollegiateOne-Regular.ttf"

  # No zap stanza required
end