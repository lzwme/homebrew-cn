cask "font-winky-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflwinkysans"
  name "Winky Sans"
  homepage "https:github.comtypofacturwinkysans"

  font "WinkySans-Italic[wght].ttf"
  font "WinkySans[wght].ttf"

  # No zap stanza required
end