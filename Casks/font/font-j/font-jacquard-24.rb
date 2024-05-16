cask "font-jacquard-24" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljacquard24Jacquard24-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jacquard 24"
  homepage "https:fonts.google.comspecimenJacquard+24"

  font "Jacquard24-Regular.ttf"

  # No zap stanza required
end