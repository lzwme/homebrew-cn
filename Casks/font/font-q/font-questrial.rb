cask "font-questrial" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflquestrialQuestrial-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Questrial"
  homepage "https:fonts.google.comspecimenQuestrial"

  font "Questrial-Regular.ttf"

  # No zap stanza required
end