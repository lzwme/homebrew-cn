cask "font-tagesschrift" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltagesschriftTagesschrift-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Tagesschrift"
  homepage "https:fonts.google.comspecimenTagesschrift"

  font "Tagesschrift-Regular.ttf"

  # No zap stanza required
end