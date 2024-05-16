cask "font-irish-grover" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapacheirishgroverIrishGrover-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Irish Grover"
  homepage "https:fonts.google.comspecimenIrish+Grover"

  font "IrishGrover-Regular.ttf"

  # No zap stanza required
end