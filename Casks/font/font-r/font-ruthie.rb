cask "font-ruthie" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflruthieRuthie-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ruthie"
  homepage "https:fonts.google.comspecimenRuthie"

  font "Ruthie-Regular.ttf"

  # No zap stanza required
end