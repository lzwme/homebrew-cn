cask "font-jacquard-12" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljacquard12Jacquard12-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jacquard 12"
  homepage "https:fonts.google.comspecimenJacquard+12"

  font "Jacquard12-Regular.ttf"

  # No zap stanza required
end