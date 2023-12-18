cask "font-kufam" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkufam"
  name "Kufam"
  desc "Arabic-Latin bilingual typeface intended for contemporary information design"
  homepage "https:fonts.google.comspecimenKufam"

  font "Kufam-Italic[wght].ttf"
  font "Kufam[wght].ttf"

  # No zap stanza required
end