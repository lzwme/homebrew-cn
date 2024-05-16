cask "font-aboreto" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflaboretoAboreto-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Aboreto"
  desc "On the thinner side"
  homepage "https:fonts.google.comspecimenAboreto"

  font "Aboreto-Regular.ttf"

  # No zap stanza required
end