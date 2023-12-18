cask "font-ruluko" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrulukoRuluko-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ruluko"
  homepage "https:fonts.google.comspecimenRuluko"

  font "Ruluko-Regular.ttf"

  # No zap stanza required
end