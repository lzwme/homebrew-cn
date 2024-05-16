cask "font-gfs-didot" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgfsdidotGFSDidot-Regular.ttf",
      verified: "github.comgooglefonts"
  name "GFS Didot"
  homepage "https:fonts.google.comspecimenGFS+Didot"

  font "GFSDidot-Regular.ttf"

  # No zap stanza required
end