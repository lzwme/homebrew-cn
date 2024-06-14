cask "font-solitreo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsolitreoSolitreo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Solitreo"
  homepage "https:fonts.google.comspecimenSolitreo"

  font "Solitreo-Regular.ttf"

  # No zap stanza required
end