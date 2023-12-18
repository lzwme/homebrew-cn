cask "font-federant" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfederantFederant-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Federant"
  homepage "https:fonts.google.comspecimenFederant"

  font "Federant-Regular.ttf"

  # No zap stanza required
end