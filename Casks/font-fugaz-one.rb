cask "font-fugaz-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfugazoneFugazOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Fugaz One"
  homepage "https:fonts.google.comspecimenFugaz+One"

  font "FugazOne-Regular.ttf"

  # No zap stanza required
end