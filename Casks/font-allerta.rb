cask "font-allerta" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflallertaAllerta-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Allerta"
  homepage "https:fonts.google.comspecimenAllerta"

  font "Allerta-Regular.ttf"

  # No zap stanza required
end