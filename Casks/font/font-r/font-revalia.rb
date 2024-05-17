cask "font-revalia" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrevaliaRevalia-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Revalia"
  homepage "https:fonts.google.comspecimenRevalia"

  font "Revalia-Regular.ttf"

  # No zap stanza required
end