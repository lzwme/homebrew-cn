cask "font-oranienbaum" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofloranienbaumOranienbaum-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Oranienbaum"
  homepage "https:fonts.google.comspecimenOranienbaum"

  font "Oranienbaum-Regular.ttf"

  # No zap stanza required
end