cask "font-orelega-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflorelegaoneOrelegaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Orelega One"
  homepage "https:fonts.google.comspecimenOrelega+One"

  font "OrelegaOne-Regular.ttf"

  # No zap stanza required
end