cask "font-lacquer" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllacquerLacquer-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Lacquer"
  homepage "https:fonts.google.comspecimenLacquer"

  font "Lacquer-Regular.ttf"

  # No zap stanza required
end