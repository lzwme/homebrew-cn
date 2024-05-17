cask "font-odibee-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflodibeesansOdibeeSans-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Odibee Sans"
  homepage "https:fonts.google.comspecimenOdibee+Sans"

  font "OdibeeSans-Regular.ttf"

  # No zap stanza required
end