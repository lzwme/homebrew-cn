cask "font-fira-code-nerd-font" do
  version "3.1.1"
  sha256 "1ad776cc5c186ff7ba1e2a05eea6701dfa57f7a1763e1db3422979301fb86209"

  url "https://ghproxy.com/https://github.com/ryanoasis/nerd-fonts/releases/download/v#{version}/FiraCode.zip"
  name "FiraCode Nerd Font (Fira Code)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https://github.com/ryanoasis/nerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "FiraCodeNerdFont-Bold.ttf"
  font "FiraCodeNerdFont-Light.ttf"
  font "FiraCodeNerdFont-Medium.ttf"
  font "FiraCodeNerdFont-Regular.ttf"
  font "FiraCodeNerdFont-Retina.ttf"
  font "FiraCodeNerdFont-SemiBold.ttf"
  font "FiraCodeNerdFontMono-Bold.ttf"
  font "FiraCodeNerdFontMono-Light.ttf"
  font "FiraCodeNerdFontMono-Medium.ttf"
  font "FiraCodeNerdFontMono-Regular.ttf"
  font "FiraCodeNerdFontMono-Retina.ttf"
  font "FiraCodeNerdFontMono-SemiBold.ttf"
  font "FiraCodeNerdFontPropo-Bold.ttf"
  font "FiraCodeNerdFontPropo-Light.ttf"
  font "FiraCodeNerdFontPropo-Medium.ttf"
  font "FiraCodeNerdFontPropo-Regular.ttf"
  font "FiraCodeNerdFontPropo-Retina.ttf"
  font "FiraCodeNerdFontPropo-SemiBold.ttf"

  # No zap stanza required
end