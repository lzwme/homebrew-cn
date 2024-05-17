cask "font-sonsie-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsonsieoneSonsieOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sonsie One"
  homepage "https:fonts.google.comspecimenSonsie+One"

  font "SonsieOne-Regular.ttf"

  # No zap stanza required
end