cask "font-alumni-sans-inline-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflalumnisansinlineone"
  name "Alumni Sans Inline One"
  homepage "https:fonts.google.comspecimenAlumni+Sans+Inline+One"

  font "AlumniSansInlineOne-Italic.ttf"
  font "AlumniSansInlineOne-Regular.ttf"

  # No zap stanza required
end