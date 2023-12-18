cask "font-bangers" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbangersBangers-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bangers"
  homepage "https:fonts.google.comspecimenBangers"

  font "Bangers-Regular.ttf"

  # No zap stanza required
end