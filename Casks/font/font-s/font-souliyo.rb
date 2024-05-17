cask "font-souliyo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsouliyoSouliyo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Souliyo"
  homepage "https:fonts.google.comearlyaccess"

  font "Souliyo-Regular.ttf"

  # No zap stanza required
end