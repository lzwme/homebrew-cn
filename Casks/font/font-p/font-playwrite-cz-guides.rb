cask "font-playwrite-cz-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteczguidesPlaywriteCZGuides-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite CZ Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+CZ+Guides"

  font "PlaywriteCZGuides-Regular.ttf"

  # No zap stanza required
end