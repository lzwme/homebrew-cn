cask "font-gulzar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgulzarGulzar-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gulzar"
  desc "Nasta’liq type for which an original latin counterpart was designed"
  homepage "https:fonts.google.comspecimenGulzar"

  font "Gulzar-Regular.ttf"

  # No zap stanza required
end