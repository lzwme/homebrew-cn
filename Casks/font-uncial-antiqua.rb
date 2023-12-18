cask "font-uncial-antiqua" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofluncialantiquaUncialAntiqua-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Uncial Antiqua"
  homepage "https:fonts.google.comspecimenUncial+Antiqua"

  font "UncialAntiqua-Regular.ttf"

  # No zap stanza required
end