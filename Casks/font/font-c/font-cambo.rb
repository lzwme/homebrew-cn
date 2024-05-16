cask "font-cambo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcamboCambo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Cambo"
  homepage "https:fonts.google.comspecimenCambo"

  font "Cambo-Regular.ttf"

  # No zap stanza required
end