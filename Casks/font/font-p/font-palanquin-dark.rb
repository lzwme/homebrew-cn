cask "font-palanquin-dark" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflpalanquindark"
  name "Palanquin Dark"
  homepage "https:fonts.google.comspecimenPalanquin+Dark"

  font "PalanquinDark-Bold.ttf"
  font "PalanquinDark-Medium.ttf"
  font "PalanquinDark-Regular.ttf"
  font "PalanquinDark-SemiBold.ttf"

  # No zap stanza required
end