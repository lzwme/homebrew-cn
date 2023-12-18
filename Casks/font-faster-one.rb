cask "font-faster-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfasteroneFasterOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Faster One"
  homepage "https:fonts.google.comspecimenFaster+One"

  font "FasterOne-Regular.ttf"

  # No zap stanza required
end