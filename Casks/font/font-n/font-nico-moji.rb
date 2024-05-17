cask "font-nico-moji" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnicomojiNicoMoji-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Nico Moji"
  homepage "https:fonts.google.comspecimenNico+Moji"

  font "NicoMoji-Regular.ttf"

  # No zap stanza required
end