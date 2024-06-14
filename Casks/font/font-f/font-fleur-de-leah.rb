cask "font-fleur-de-leah" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfleurdeleahFleurDeLeah-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Fleur De Leah"
  homepage "https:fonts.google.comspecimenFleur+De+Leah"

  font "FleurDeLeah-Regular.ttf"

  # No zap stanza required
end