cask "font-bytesized" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbytesizedBytesized-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bytesized"
  homepage "https:fonts.google.comspecimenBytesized"

  font "Bytesized-Regular.ttf"

  # No zap stanza required
end