cask "font-karantina" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkarantina"
  name "Karantina"
  homepage "https:fonts.google.comspecimenKarantina"

  font "Karantina-Bold.ttf"
  font "Karantina-Light.ttf"
  font "Karantina-Regular.ttf"

  # No zap stanza required
end