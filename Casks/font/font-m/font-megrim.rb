cask "font-megrim" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmegrimMegrim.ttf",
      verified: "github.comgooglefonts"
  name "Megrim"
  homepage "https:fonts.google.comspecimenMegrim"

  font "Megrim.ttf"

  # No zap stanza required
end