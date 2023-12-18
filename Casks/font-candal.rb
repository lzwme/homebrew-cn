cask "font-candal" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcandalCandal.ttf",
      verified: "github.comgooglefonts"
  name "Candal"
  homepage "https:fonts.google.comspecimenCandal"

  font "Candal.ttf"

  # No zap stanza required
end