cask "font-funnel-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflfunnelsans"
  name "Funnel Sans"
  homepage "https:github.comDicotypeFunnel"

  font "FunnelSans-Italic[wght].ttf"
  font "FunnelSans[wght].ttf"

  # No zap stanza required
end