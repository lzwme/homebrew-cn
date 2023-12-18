cask "font-fjalla-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfjallaoneFjallaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Fjalla One"
  homepage "https:fonts.google.comspecimenFjalla+One"

  font "FjallaOne-Regular.ttf"

  # No zap stanza required
end