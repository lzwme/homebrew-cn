cask "font-sansita-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsansitaoneSansitaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sansita One"
  homepage "https:fonts.google.comspecimenSansita+One"

  font "SansitaOne-Regular.ttf"

  # No zap stanza required
end