cask "font-ole" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofloleOle-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ole"
  homepage "https:fonts.google.comspecimenOle"

  font "Ole-Regular.ttf"

  # No zap stanza required
end