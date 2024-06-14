cask "font-send-flowers" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsendflowersSendFlowers-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Send Flowers"
  homepage "https:fonts.google.comspecimenSend+Flowers"

  font "SendFlowers-Regular.ttf"

  # No zap stanza required
end