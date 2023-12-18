cask "font-rock-3d" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrock3dRock3D-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rock 3D"
  homepage "https:fonts.google.comspecimenRock+3D"

  font "Rock3D-Regular.ttf"

  # No zap stanza required
end