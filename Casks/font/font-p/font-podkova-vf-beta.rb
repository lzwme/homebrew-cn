cask "font-podkova-vf-beta" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpodkovavfbetaPodkovaVFBeta.ttf",
      verified: "github.comgooglefonts"
  name "Podkova VF Beta"
  homepage "https:fonts.google.comearlyaccess"

  font "PodkovaVFBeta.ttf"

  # No zap stanza required
end