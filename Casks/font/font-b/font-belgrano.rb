cask "font-belgrano" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbelgranoBelgrano-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Belgrano"
  homepage "https:fonts.google.comspecimenBelgrano"

  font "Belgrano-Regular.ttf"

  # No zap stanza required
end