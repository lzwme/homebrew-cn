cask "font-playpen-sans-thai" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaypensansthaiPlaypenSansThai%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playpen Sans Thai"
  homepage "https:fonts.google.comspecimenPlaypen+Sans+Thai"

  font "PlaypenSansThai[wght].ttf"

  # No zap stanza required
end