cask "font-space-mono" do
  version :latest
  sha256 :no_check

  url "https://ghfast.top/https://github.com/googlefonts/spacemono/archive/refs/heads/master.tar.gz"
  name "Space Mono"
  homepage "https://github.com/googlefonts/spacemono"

  font "spacemono-main/fonts/ttf/SpaceMono-Bold.ttf"
  font "spacemono-main/fonts/ttf/SpaceMono-BoldItalic.ttf"
  font "spacemono-main/fonts/ttf/SpaceMono-Italic.ttf"
  font "spacemono-main/fonts/ttf/SpaceMono-Regular.ttf"

  # No zap stanza required
end