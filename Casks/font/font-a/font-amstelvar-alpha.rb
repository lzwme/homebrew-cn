cask "font-amstelvar-alpha" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflamstelvaralphaAmstelvarAlpha-VF.ttf",
      verified: "github.comgooglefonts"
  name "Amstelvar Alpha"
  homepage "https:fonts.google.comearlyaccess"

  font "AmstelvarAlpha-VF.ttf"

  # No zap stanza required
end