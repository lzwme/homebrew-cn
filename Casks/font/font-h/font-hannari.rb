cask "font-hannari" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhannariHannari-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Hannari"
  homepage "https:fonts.google.comspecimenHannari"

  font "Hannari-Regular.ttf"

  # No zap stanza required
end