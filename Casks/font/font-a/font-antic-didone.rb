cask "font-antic-didone" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanticdidoneAnticDidone-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Antic Didone"
  homepage "https:fonts.google.comspecimenAntic+Didone"

  font "AnticDidone-Regular.ttf"

  # No zap stanza required
end