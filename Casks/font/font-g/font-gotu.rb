cask "font-gotu" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgotuGotu-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gotu"
  homepage "https:fonts.google.comspecimenGotu"

  font "Gotu-Regular.ttf"

  # No zap stanza required
end