cask "font-libertinus-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllibertinusmonoLibertinusMono-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Libertinus Mono"
  homepage "https:fonts.google.comspecimenLibertinus+Mono"

  font "LibertinusMono-Regular.ttf"

  # No zap stanza required
end