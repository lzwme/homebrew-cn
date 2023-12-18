cask "font-sigmar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsigmarSigmar-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sigmar"
  homepage "https:fonts.google.comspecimenSigmar"

  font "Sigmar-Regular.ttf"

  # No zap stanza required
end