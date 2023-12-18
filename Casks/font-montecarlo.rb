cask "font-montecarlo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmontecarloMonteCarlo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "MonteCarlo"
  desc "Perfect for an ornate look and a readable message"
  homepage "https:fonts.google.comspecimenMonteCarlo"

  font "MonteCarlo-Regular.ttf"

  # No zap stanza required
end