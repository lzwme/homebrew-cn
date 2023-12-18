cask "font-signika" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsignikaSignika%5BGRAD%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Signika"
  desc "Sans-serif signage typeface with a gentle character"
  homepage "https:fonts.google.comspecimenSignika"

  font "Signika[GRAD,wght].ttf"

  # No zap stanza required
end