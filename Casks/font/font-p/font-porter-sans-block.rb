cask "font-porter-sans-block" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflportersansblockPorterSansBlock-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Porter Sans Block"
  homepage "https:fonts.google.comspecimenPorter+Sans+Block"

  font "PorterSansBlock-Regular.ttf"

  # No zap stanza required
end