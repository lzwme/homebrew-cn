cask "font-montserrat-underline" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflmontserratunderline"
  name "Montserrat Underline"
  homepage "https:github.comJulietaUlaMontserrat"

  font "MontserratUnderline-Italic[wght].ttf"
  font "MontserratUnderline[wght].ttf"

  # No zap stanza required
end