cask "font-anton" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflantonAnton-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Anton"
  homepage "https:fonts.google.comspecimenAnton"

  font "Anton-Regular.ttf"

  # No zap stanza required
end