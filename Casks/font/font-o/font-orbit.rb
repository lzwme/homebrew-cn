cask "font-orbit" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflorbitOrbit-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Orbit"
  homepage "https:fonts.google.comspecimenOrbit"

  font "Orbit-Regular.ttf"

  # No zap stanza required
end