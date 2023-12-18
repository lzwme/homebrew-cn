cask "font-antic-slab" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanticslabAnticSlab-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Antic Slab"
  homepage "https:fonts.google.comspecimenAntic+Slab"

  font "AnticSlab-Regular.ttf"

  # No zap stanza required
end