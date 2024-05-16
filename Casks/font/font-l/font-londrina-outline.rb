cask "font-londrina-outline" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllondrinaoutlineLondrinaOutline-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Londrina Outline"
  homepage "https:fonts.google.comspecimenLondrina+Outline"

  font "LondrinaOutline-Regular.ttf"

  # No zap stanza required
end