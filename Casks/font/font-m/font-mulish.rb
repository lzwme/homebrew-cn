cask "font-mulish" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmulish"
  name "Mulish"
  homepage "https:fonts.google.comspecimenMulish"

  font "Mulish-Italic[wght].ttf"
  font "Mulish[wght].ttf"

  # No zap stanza required
end