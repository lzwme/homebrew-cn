cask "font-fascinate" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfascinateFascinate-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Fascinate"
  homepage "https:fonts.google.comspecimenFascinate"

  font "Fascinate-Regular.ttf"

  # No zap stanza required
end