cask "font-kantumruy-pro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkantumruypro"
  name "Kantumruy Pro"
  desc "From work sans, with modified width and weight"
  homepage "https:fonts.google.comspecimenKantumruy+Pro"

  font "KantumruyPro-Italic[wght].ttf"
  font "KantumruyPro[wght].ttf"

  # No zap stanza required
end