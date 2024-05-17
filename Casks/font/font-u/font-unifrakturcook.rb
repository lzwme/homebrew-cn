cask "font-unifrakturcook" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflunifrakturcookUnifrakturCook-Bold.ttf",
      verified: "github.comgooglefonts"
  name "UnifrakturCook"
  homepage "https:fonts.google.comspecimenUnifrakturCook"

  font "UnifrakturCook-Bold.ttf"

  # No zap stanza required
end