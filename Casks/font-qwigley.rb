cask "font-qwigley" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflqwigleyQwigley-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Qwigley"
  homepage "https:fonts.google.comspecimenQwigley"

  font "Qwigley-Regular.ttf"

  # No zap stanza required
end