cask "font-limelight" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllimelightLimelight-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Limelight"
  homepage "https:fonts.google.comspecimenLimelight"

  font "Limelight-Regular.ttf"

  # No zap stanza required
end