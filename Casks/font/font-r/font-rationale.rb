cask "font-rationale" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrationaleRationale-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rationale"
  homepage "https:fonts.google.comspecimenRationale"

  font "Rationale-Regular.ttf"

  # No zap stanza required
end