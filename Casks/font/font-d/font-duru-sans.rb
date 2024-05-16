cask "font-duru-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldurusansDuruSans-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Duru Sans"
  homepage "https:fonts.google.comspecimenDuru+Sans"

  font "DuruSans-Regular.ttf"

  # No zap stanza required
end