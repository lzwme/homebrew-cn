cask "font-assistant" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflassistantAssistant%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Assistant"
  homepage "https:fonts.google.comspecimenAssistant"

  font "Assistant[wght].ttf"

  # No zap stanza required
end