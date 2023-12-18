cask "font-didact-gothic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldidactgothicDidactGothic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Didact Gothic"
  homepage "https:fonts.google.comspecimenDidact+Gothic"

  font "DidactGothic-Regular.ttf"

  # No zap stanza required
end