cask "font-monofur-nerd-font" do
  version "3.1.0"
  sha256 "37780c2709da928a603f79924747c9c9c9725aa589a3647363f78e2bb37b1957"

  url "https://ghproxy.com/https://github.com/ryanoasis/nerd-fonts/releases/download/v#{version}/Monofur.zip"
  name "Monofur Nerd Font (Monofur)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https://github.com/ryanoasis/nerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "MonofurNerdFont-Bold.ttf"
  font "MonofurNerdFont-Italic.ttf"
  font "MonofurNerdFont-Regular.ttf"
  font "MonofurNerdFontMono-Bold.ttf"
  font "MonofurNerdFontMono-Italic.ttf"
  font "MonofurNerdFontMono-Regular.ttf"
  font "MonofurNerdFontPropo-Bold.ttf"
  font "MonofurNerdFontPropo-Italic.ttf"
  font "MonofurNerdFontPropo-Regular.ttf"

  # No zap stanza required
end