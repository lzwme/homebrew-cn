cask "font-lalezar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllalezarLalezar-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Lalezar"
  homepage "https:fonts.google.comspecimenLalezar"

  font "Lalezar-Regular.ttf"

  # No zap stanza required
end