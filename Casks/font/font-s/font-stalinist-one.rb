cask "font-stalinist-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflstalinistoneStalinistOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Stalinist One"
  homepage "https:fonts.google.comspecimenStalinist+One"

  font "StalinistOne-Regular.ttf"

  # No zap stanza required
end