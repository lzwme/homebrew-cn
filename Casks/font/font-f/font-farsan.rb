cask "font-farsan" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfarsanFarsan-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Farsan"
  homepage "https:fonts.google.comspecimenFarsan"

  font "Farsan-Regular.ttf"

  # No zap stanza required
end