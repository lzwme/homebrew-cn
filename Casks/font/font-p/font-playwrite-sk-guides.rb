cask "font-playwrite-sk-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteskguidesPlaywriteSKGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite SK Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+SK+Guides"

  font "PlaywriteSKGuides-Regular.ttf"

  # No zap stanza required
end