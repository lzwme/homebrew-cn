cask "font-kranky" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachekrankyKranky-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kranky"
  homepage "https:fonts.google.comspecimenKranky"

  font "Kranky-Regular.ttf"

  # No zap stanza required
end