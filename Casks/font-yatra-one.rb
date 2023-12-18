cask "font-yatra-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflyatraoneYatraOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Yatra One"
  homepage "https:fonts.google.comspecimenYatra+One"

  font "YatraOne-Regular.ttf"

  # No zap stanza required
end