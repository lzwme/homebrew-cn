cask "font-playwrite-cl" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteclPlaywriteCL%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite CL"
  homepage "https:fonts.google.comspecimenPlaywrite+CL"

  font "PlaywriteCL[wght].ttf"

  # No zap stanza required
end