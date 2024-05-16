cask "font-inter-tight" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflintertight"
  name "Inter Tight"
  homepage "https:fonts.google.comspecimenInter+Tight"

  font "InterTight-Italic[wght].ttf"
  font "InterTight[wght].ttf"

  # No zap stanza required
end