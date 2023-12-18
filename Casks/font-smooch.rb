cask "font-smooch" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsmoochSmooch-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Smooch"
  desc "Slightly bolder than other hand-lettered scripts"
  homepage "https:fonts.google.comspecimenSmooch"

  font "Smooch-Regular.ttf"

  # No zap stanza required
end