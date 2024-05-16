cask "font-besley" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbesley"
  name "Besley"
  desc "Designed by owen earl (indestructible type*)"
  homepage "https:fonts.google.comspecimenBesley"

  font "Besley-Italic[wght].ttf"
  font "Besley[wght].ttf"

  # No zap stanza required
end