cask "font-kaushan-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkaushanscriptKaushanScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kaushan Script"
  homepage "https:fonts.google.comspecimenKaushan+Script"

  font "KaushanScript-Regular.ttf"

  # No zap stanza required
end