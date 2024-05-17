cask "font-telex" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltelexTelex-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Telex"
  homepage "https:fonts.google.comspecimenTelex"

  font "Telex-Regular.ttf"

  # No zap stanza required
end