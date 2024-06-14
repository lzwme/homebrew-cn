cask "font-neonderthaw" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflneonderthawNeonderthaw-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Neonderthaw"
  homepage "https:fonts.google.comspecimenNeonderthaw"

  font "Neonderthaw-Regular.ttf"

  # No zap stanza required
end