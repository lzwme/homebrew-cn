cask "font-liberation-nerd-font" do
  version "3.1.0"
  sha256 "19805bc283f1037050b2e31d0ca2e6108c6f3c117897c4a99aca26b2bfb499c7"

  url "https://ghproxy.com/https://github.com/ryanoasis/nerd-fonts/releases/download/v#{version}/LiberationMono.zip"
  name "Literation Nerd Font families (Liberation Mono)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https://github.com/ryanoasis/nerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "LiterationMonoNerdFont-Bold.ttf"
  font "LiterationMonoNerdFont-BoldItalic.ttf"
  font "LiterationMonoNerdFont-Italic.ttf"
  font "LiterationMonoNerdFont-Regular.ttf"
  font "LiterationMonoNerdFontMono-Bold.ttf"
  font "LiterationMonoNerdFontMono-BoldItalic.ttf"
  font "LiterationMonoNerdFontMono-Italic.ttf"
  font "LiterationMonoNerdFontMono-Regular.ttf"
  font "LiterationMonoNerdFontPropo-Bold.ttf"
  font "LiterationMonoNerdFontPropo-BoldItalic.ttf"
  font "LiterationMonoNerdFontPropo-Italic.ttf"
  font "LiterationMonoNerdFontPropo-Regular.ttf"
  font "LiterationSansNerdFont-Bold.ttf"
  font "LiterationSansNerdFont-BoldItalic.ttf"
  font "LiterationSansNerdFont-Italic.ttf"
  font "LiterationSansNerdFont-Regular.ttf"
  font "LiterationSansNerdFontPropo-Bold.ttf"
  font "LiterationSansNerdFontPropo-BoldItalic.ttf"
  font "LiterationSansNerdFontPropo-Italic.ttf"
  font "LiterationSansNerdFontPropo-Regular.ttf"
  font "LiterationSerifNerdFont-Bold.ttf"
  font "LiterationSerifNerdFont-BoldItalic.ttf"
  font "LiterationSerifNerdFont-Italic.ttf"
  font "LiterationSerifNerdFont-Regular.ttf"
  font "LiterationSerifNerdFontPropo-Bold.ttf"
  font "LiterationSerifNerdFontPropo-BoldItalic.ttf"
  font "LiterationSerifNerdFontPropo-Italic.ttf"
  font "LiterationSerifNerdFontPropo-Regular.ttf"

  # No zap stanza required
end