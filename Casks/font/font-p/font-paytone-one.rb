cask "font-paytone-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpaytoneonePaytoneOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Paytone One"
  homepage "https:fonts.google.comspecimenPaytone+One"

  font "PaytoneOne-Regular.ttf"

  # No zap stanza required
end