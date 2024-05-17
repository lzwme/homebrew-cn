cask "font-noto-serif-khitan-small-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifkhitansmallscriptNotoSerifKhitanSmallScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Khitan Small Script"
  desc "Design for the historical east asian khitan small script script"
  homepage "https:fonts.google.comspecimenNoto+Serif+Khitan+Small+Script"

  font "NotoSerifKhitanSmallScript-Regular.ttf"

  # No zap stanza required
end