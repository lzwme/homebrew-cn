cask "font-suez-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsuezoneSuezOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Suez One"
  homepage "https:fonts.google.comspecimenSuez+One"

  font "SuezOne-Regular.ttf"

  # No zap stanza required
end