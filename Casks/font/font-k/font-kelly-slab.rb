cask "font-kelly-slab" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkellyslabKellySlab-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kelly Slab"
  homepage "https:fonts.google.comspecimenKelly+Slab"

  font "KellySlab-Regular.ttf"

  # No zap stanza required
end