cask "font-playwrite-mx-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritemxguidesPlaywriteMXGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite MX Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+MX+Guides"

  font "PlaywriteMXGuides-Regular.ttf"

  # No zap stanza required
end