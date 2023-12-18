cask "font-harmattan" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflharmattan"
  name "Harmattan"
  homepage "https:fonts.google.comspecimenHarmattan"

  font "Harmattan-Bold.ttf"
  font "Harmattan-Medium.ttf"
  font "Harmattan-Regular.ttf"
  font "Harmattan-SemiBold.ttf"

  # No zap stanza required
end