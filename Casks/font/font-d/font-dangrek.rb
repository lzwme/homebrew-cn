cask "font-dangrek" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldangrekDangrek-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Dangrek"
  homepage "https:fonts.google.comspecimenDangrek"

  font "Dangrek-Regular.ttf"

  # No zap stanza required
end