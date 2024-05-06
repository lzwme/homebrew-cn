cask "font-freeman" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfreemanFreeman-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Freeman"
  desc "Re-interpretation of the traditional display sans serif gothic typeface"
  homepage "https:fonts.google.comspecimenFreeman"

  font "Freeman-Regular.ttf"

  # No zap stanza required
end