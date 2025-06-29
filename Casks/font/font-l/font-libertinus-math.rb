cask "font-libertinus-math" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllibertinusmathLibertinusMath-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Libertinus Math"
  homepage "https:fonts.google.comspecimenLibertinus+Math"

  font "LibertinusMath-Regular.ttf"

  # No zap stanza required
end