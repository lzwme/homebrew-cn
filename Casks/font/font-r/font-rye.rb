cask "font-rye" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflryeRye-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rye"
  homepage "https:fonts.google.comspecimenRye"

  font "Rye-Regular.ttf"

  # No zap stanza required
end