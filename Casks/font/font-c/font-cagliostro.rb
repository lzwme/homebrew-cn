cask "font-cagliostro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcagliostroCagliostro-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Cagliostro"
  homepage "https:fonts.google.comspecimenCagliostro"

  font "Cagliostro-Regular.ttf"

  # No zap stanza required
end