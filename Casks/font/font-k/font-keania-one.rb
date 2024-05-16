cask "font-keania-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkeaniaoneKeaniaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Keania One"
  homepage "https:fonts.google.comspecimenKeania+One"

  font "KeaniaOne-Regular.ttf"

  # No zap stanza required
end