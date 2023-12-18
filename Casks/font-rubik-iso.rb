cask "font-rubik-iso" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikisoRubikIso-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Iso"
  homepage "https:fonts.google.comspecimenRubik+Iso"

  font "RubikIso-Regular.ttf"

  # No zap stanza required
end