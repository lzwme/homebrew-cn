cask "font-amethysta" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflamethystaAmethysta-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Amethysta"
  homepage "https:fonts.google.comspecimenAmethysta"

  font "Amethysta-Regular.ttf"

  # No zap stanza required
end