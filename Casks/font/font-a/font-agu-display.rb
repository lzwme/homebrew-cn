cask "font-agu-display" do
  version :latest
  sha256 :no_check

  url "https://github.com/google/fonts/raw/main/ofl/agudisplay/AguDisplay%5BMORF%5D.ttf",
      verified: "github.com/google/fonts/"
  name "Agu Display"
  homepage "https://fonts.google.com/specimen/Agu+Display"

  font "AguDisplay[MORF].ttf"

  # No zap stanza required
end