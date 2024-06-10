cask "font-tiny5" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltiny5Tiny5-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Tiny5"
  homepage "https:fonts.google.comspecimenTiny5"

  font "Tiny5-Regular.ttf"

  # No zap stanza required
end