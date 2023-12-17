cask "font-playwrite-co" do
  version :latest
  sha256 :no_check

  url "https://github.com/google/fonts/raw/main/ofl/playwriteco/PlaywriteCO%5Bwght%5D.ttf"
  name "Playwrite CO"
  homepage "https://github.com/TypeTogether/Playwrite/"

  font "PlaywriteCO[wght].ttf"

  # No zap stanza required
end