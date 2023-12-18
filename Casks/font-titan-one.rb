cask "font-titan-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltitanoneTitanOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Titan One"
  homepage "https:fonts.google.comspecimenTitan+One"

  font "TitanOne-Regular.ttf"

  # No zap stanza required
end