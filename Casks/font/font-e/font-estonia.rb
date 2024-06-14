cask "font-estonia" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflestoniaEstonia-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Estonia"
  homepage "https:fonts.google.comspecimenEstonia"

  font "Estonia-Regular.ttf"

  # No zap stanza required
end