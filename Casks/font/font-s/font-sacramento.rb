cask "font-sacramento" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsacramentoSacramento-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sacramento"
  homepage "https:fonts.google.comspecimenSacramento"

  font "Sacramento-Regular.ttf"

  # No zap stanza required
end