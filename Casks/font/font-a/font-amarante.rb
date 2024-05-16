cask "font-amarante" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflamaranteAmarante-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Amarante"
  homepage "https:fonts.google.comspecimenAmarante"

  font "Amarante-Regular.ttf"

  # No zap stanza required
end