cask "font-ewert" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflewertEwert-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ewert"
  homepage "https:fonts.google.comspecimenEwert"

  font "Ewert-Regular.ttf"

  # No zap stanza required
end