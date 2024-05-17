cask "font-original-surfer" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofloriginalsurferOriginalSurfer-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Original Surfer"
  homepage "https:fonts.google.comspecimenOriginal+Surfer"

  font "OriginalSurfer-Regular.ttf"

  # No zap stanza required
end