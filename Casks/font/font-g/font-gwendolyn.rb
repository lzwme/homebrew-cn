cask "font-gwendolyn" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgwendolyn"
  name "Gwendolyn"
  homepage "https:fonts.google.comspecimenGwendolyn"

  font "Gwendolyn-Bold.ttf"
  font "Gwendolyn-Regular.ttf"

  # No zap stanza required
end