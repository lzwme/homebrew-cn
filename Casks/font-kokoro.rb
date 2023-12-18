cask "font-kokoro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkokoroKokoro-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kokoro"
  homepage "https:fonts.google.comspecimenKokoro"

  font "Kokoro-Regular.ttf"

  # No zap stanza required
end