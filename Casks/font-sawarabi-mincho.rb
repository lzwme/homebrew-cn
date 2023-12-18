cask "font-sawarabi-mincho" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsawarabiminchoSawarabiMincho-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sawarabi Mincho"
  homepage "https:fonts.google.comspecimenSawarabi+Mincho"

  font "SawarabiMincho-Regular.ttf"

  # No zap stanza required
end