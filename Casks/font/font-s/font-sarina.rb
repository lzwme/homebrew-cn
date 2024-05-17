cask "font-sarina" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsarinaSarina-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sarina"
  homepage "https:fonts.google.comspecimenSarina"

  font "Sarina-Regular.ttf"

  # No zap stanza required
end