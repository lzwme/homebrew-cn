cask "font-yinmar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflyinmarYinmar-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Yinmar"
  homepage "https:fonts.google.comspecimenYinmar"

  font "Yinmar-Regular.ttf"

  # No zap stanza required
end