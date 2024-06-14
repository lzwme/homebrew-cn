cask "font-radio-canada-big" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflradiocanadabig"
  name "Radio Canada Big"
  homepage "https:fonts.google.comspecimenRadio+Canada+Big"

  font "RadioCanadaBig-Italic[wght].ttf"
  font "RadioCanadaBig[wght].ttf"

  # No zap stanza required
end