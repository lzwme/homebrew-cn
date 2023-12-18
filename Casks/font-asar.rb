cask "font-asar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflasarAsar-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Asar"
  homepage "https:fonts.google.comspecimenAsar"

  font "Asar-Regular.ttf"

  # No zap stanza required
end