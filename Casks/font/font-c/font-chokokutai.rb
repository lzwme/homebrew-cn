cask "font-chokokutai" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflchokokutaiChokokutai-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Chokokutai"
  homepage "https:fonts.google.comspecimenChokokutai"

  font "Chokokutai-Regular.ttf"

  # No zap stanza required
end