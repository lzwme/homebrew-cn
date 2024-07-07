cask "font-anton-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflantonscAntonSC-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Anton SC"
  homepage "https:fonts.google.comspecimenAnton+SC"

  font "AntonSC-Regular.ttf"

  # No zap stanza required
end