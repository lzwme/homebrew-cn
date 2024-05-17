cask "font-sawarabi-gothic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsawarabigothicSawarabiGothic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sawarabi Gothic"
  homepage "https:fonts.google.comspecimenSawarabi+Gothic"

  font "SawarabiGothic-Regular.ttf"

  # No zap stanza required
end