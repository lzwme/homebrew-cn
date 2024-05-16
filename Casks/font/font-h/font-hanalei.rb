cask "font-hanalei" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhanaleiHanalei-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Hanalei"
  homepage "https:fonts.google.comspecimenHanalei"

  font "Hanalei-Regular.ttf"

  # No zap stanza required
end