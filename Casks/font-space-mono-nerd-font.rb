cask "font-space-mono-nerd-font" do
  version "3.1.0"
  sha256 "a6c732bf09836a767e23af2d0bb6b09ac446f268445592407af518e0749d19c0"

  url "https://ghproxy.com/https://github.com/ryanoasis/nerd-fonts/releases/download/v#{version}/SpaceMono.zip"
  name "SpaceMono Nerd Font (Space Mono)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https://github.com/ryanoasis/nerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "SpaceMonoNerdFont-Bold.ttf"
  font "SpaceMonoNerdFont-BoldItalic.ttf"
  font "SpaceMonoNerdFont-Italic.ttf"
  font "SpaceMonoNerdFont-Regular.ttf"
  font "SpaceMonoNerdFontMono-Bold.ttf"
  font "SpaceMonoNerdFontMono-BoldItalic.ttf"
  font "SpaceMonoNerdFontMono-Italic.ttf"
  font "SpaceMonoNerdFontMono-Regular.ttf"
  font "SpaceMonoNerdFontPropo-Bold.ttf"
  font "SpaceMonoNerdFontPropo-BoldItalic.ttf"
  font "SpaceMonoNerdFontPropo-Italic.ttf"
  font "SpaceMonoNerdFontPropo-Regular.ttf"

  # No zap stanza required
end