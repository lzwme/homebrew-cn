cask "font-metal-mania" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmetalmaniaMetalMania-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Metal Mania"
  homepage "https:fonts.google.comspecimenMetal+Mania"

  font "MetalMania-Regular.ttf"

  # No zap stanza required
end