cask "font-anuphan" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanuphanAnuphan%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Anuphan"
  desc "Not a modification of ibm plex sans thai"
  homepage "https:fonts.google.comspecimenAnuphan"

  font "Anuphan[wght].ttf"

  # No zap stanza required
end