cask "font-playwrite-hr-lijeva" do
  version :latest
  sha256 :no_check

  url "https://github.com/google/fonts/raw/main/ofl/playwritehrlijeva/PlaywriteHRLijeva%5Bwght%5D.ttf",
      verified: "github.com/google/fonts/"
  name "Playwrite HR Lijeva"
  homepage "https://fonts.google.com/specimen/Playwrite+HR+Lijeva"

  font "PlaywriteHRLijeva[wght].ttf"

  # No zap stanza required
end