cask "font-monomakh" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmonomakhMonomakh-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Monomakh"
  homepage "https:fonts.google.comspecimenMonomakh"

  font "Monomakh-Regular.ttf"

  # No zap stanza required
end