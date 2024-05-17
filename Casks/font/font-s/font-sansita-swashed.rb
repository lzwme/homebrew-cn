cask "font-sansita-swashed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsansitaswashedSansitaSwashed%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Sansita Swashed"
  desc "Beautiful display font in vintage form"
  homepage "https:fonts.google.comspecimenSansita+Swashed"

  font "SansitaSwashed[wght].ttf"

  # No zap stanza required
end