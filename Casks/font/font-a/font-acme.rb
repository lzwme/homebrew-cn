cask "font-acme" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflacmeAcme-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Acme"
  homepage "https:fonts.google.comspecimenAcme"

  font "Acme-Regular.ttf"

  # No zap stanza required
end