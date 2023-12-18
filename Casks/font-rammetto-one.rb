cask "font-rammetto-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrammettooneRammettoOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rammetto One"
  homepage "https:fonts.google.comspecimenRammetto+One"

  font "RammettoOne-Regular.ttf"

  # No zap stanza required
end