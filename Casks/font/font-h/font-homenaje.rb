cask "font-homenaje" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhomenajeHomenaje-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Homenaje"
  homepage "https:fonts.google.comspecimenHomenaje"

  font "Homenaje-Regular.ttf"

  # No zap stanza required
end