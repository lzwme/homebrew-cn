cask "font-pacifico" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpacificoPacifico-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Pacifico"
  homepage "https:fonts.google.comspecimenPacifico"

  font "Pacifico-Regular.ttf"

  # No zap stanza required
end