cask "font-plus-jakarta-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflplusjakartasans"
  name "Plus Jakarta Sans"
  desc "Versatile modern type family"
  homepage "https:fonts.google.comspecimenPlus+Jakarta+Sans"

  font "PlusJakartaSans-Italic[wght].ttf"
  font "PlusJakartaSans[wght].ttf"

  # No zap stanza required
end