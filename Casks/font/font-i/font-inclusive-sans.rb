cask "font-inclusive-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflinclusivesans"
  name "Inclusive Sans"
  homepage "https:fonts.google.comspecimenInclusive+Sans"

  font "InclusiveSans-Italic[wght].ttf"
  font "InclusiveSans[wght].ttf"

  # No zap stanza required
end