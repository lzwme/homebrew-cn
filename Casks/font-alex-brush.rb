cask "font-alex-brush" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflalexbrushAlexBrush-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Alex Brush"
  homepage "https:fonts.google.comspecimenAlex+Brush"

  font "AlexBrush-Regular.ttf"

  # No zap stanza required
end