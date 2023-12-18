cask "font-sigmar-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsigmaroneSigmarOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sigmar One"
  homepage "https:fonts.google.comspecimenSigmar+One"

  font "SigmarOne-Regular.ttf"

  # No zap stanza required
end