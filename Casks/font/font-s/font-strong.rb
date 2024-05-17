cask "font-strong" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflstrongStrong-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Strong"
  homepage "https:fonts.google.comspecimenStrong"

  font "Strong-Regular.ttf"

  # No zap stanza required
end