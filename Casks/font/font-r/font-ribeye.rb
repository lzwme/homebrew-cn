cask "font-ribeye" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflribeyeRibeye-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ribeye"
  homepage "https:fonts.google.comspecimenRibeye"

  font "Ribeye-Regular.ttf"

  # No zap stanza required
end