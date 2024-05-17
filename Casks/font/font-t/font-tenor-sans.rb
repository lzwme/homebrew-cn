cask "font-tenor-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltenorsansTenorSans-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Tenor Sans"
  homepage "https:fonts.google.comspecimenTenor+Sans"

  font "TenorSans-Regular.ttf"

  # No zap stanza required
end