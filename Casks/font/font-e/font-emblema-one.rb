cask "font-emblema-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflemblemaoneEmblemaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Emblema One"
  homepage "https:fonts.google.comspecimenEmblema+One"

  font "EmblemaOne-Regular.ttf"

  # No zap stanza required
end