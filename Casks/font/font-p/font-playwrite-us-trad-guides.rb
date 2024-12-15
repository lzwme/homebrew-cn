cask "font-playwrite-us-trad-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteustradguidesPlaywriteUSTradGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite US Trad Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+US+Trad+Guides"

  font "PlaywriteUSTradGuides-Regular.ttf"

  # No zap stanza required
end