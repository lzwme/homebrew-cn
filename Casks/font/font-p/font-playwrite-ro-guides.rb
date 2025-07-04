cask "font-playwrite-ro-guides" do
  version :latest
  sha256 :no_check

  url "https://github.com/google/fonts/raw/main/ofl/playwriteroguides/PlaywriteROGuides-Regular.ttf",
      verified: "github.com/google/fonts/"
  name "Playwrite RO Guides"
  homepage "https://fonts.google.com/specimen/Playwrite+RO+Guides"

  font "PlaywriteROGuides-Regular.ttf"

  # No zap stanza required
end