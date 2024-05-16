cask "font-doppio-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldoppiooneDoppioOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Doppio One"
  homepage "https:fonts.google.comspecimenDoppio+One"

  font "DoppioOne-Regular.ttf"

  # No zap stanza required
end