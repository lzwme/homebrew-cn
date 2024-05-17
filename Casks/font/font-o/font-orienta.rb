cask "font-orienta" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflorientaOrienta-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Orienta"
  homepage "https:fonts.google.comspecimenOrienta"

  font "Orienta-Regular.ttf"

  # No zap stanza required
end