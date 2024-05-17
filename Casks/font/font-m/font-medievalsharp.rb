cask "font-medievalsharp" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmedievalsharpMedievalSharp.ttf",
      verified: "github.comgooglefonts"
  name "MedievalSharp"
  homepage "https:fonts.google.comspecimenMedievalSharp"

  font "MedievalSharp.ttf"

  # No zap stanza required
end