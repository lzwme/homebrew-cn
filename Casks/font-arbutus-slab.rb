cask "font-arbutus-slab" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflarbutusslabArbutusSlab-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Arbutus Slab"
  homepage "https:fonts.google.comspecimenArbutus+Slab"

  font "ArbutusSlab-Regular.ttf"

  # No zap stanza required
end