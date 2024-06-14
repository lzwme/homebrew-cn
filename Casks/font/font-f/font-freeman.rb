cask "font-freeman" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfreemanFreeman-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Freeman"
  homepage "https:fonts.google.comspecimenFreeman"

  font "Freeman-Regular.ttf"

  # No zap stanza required
end