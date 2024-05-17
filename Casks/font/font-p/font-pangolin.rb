cask "font-pangolin" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpangolinPangolin-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Pangolin"
  homepage "https:fonts.google.comspecimenPangolin"

  font "Pangolin-Regular.ttf"

  # No zap stanza required
end