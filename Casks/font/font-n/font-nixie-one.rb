cask "font-nixie-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnixieoneNixieOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Nixie One"
  homepage "https:fonts.google.comspecimenNixie+One"

  font "NixieOne-Regular.ttf"

  # No zap stanza required
end