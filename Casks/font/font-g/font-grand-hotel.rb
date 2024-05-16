cask "font-grand-hotel" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgrandhotelGrandHotel-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Grand Hotel"
  homepage "https:fonts.google.comspecimenGrand+Hotel"

  font "GrandHotel-Regular.ttf"

  # No zap stanza required
end