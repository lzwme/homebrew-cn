cask "font-bigelow-rules" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbigelowrulesBigelowRules-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bigelow Rules"
  homepage "https:fonts.google.comspecimenBigelow+Rules"

  font "BigelowRules-Regular.ttf"

  # No zap stanza required
end