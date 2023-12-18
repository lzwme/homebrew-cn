cask "font-seaweed-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflseaweedscriptSeaweedScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Seaweed Script"
  homepage "https:fonts.google.comspecimenSeaweed+Script"

  font "SeaweedScript-Regular.ttf"

  # No zap stanza required
end