cask "font-miama" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmiamaMiama-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Miama"
  homepage "https:fonts.google.comspecimenMiama"

  font "Miama-Regular.ttf"

  # No zap stanza required
end