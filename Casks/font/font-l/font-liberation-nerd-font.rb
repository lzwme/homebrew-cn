cask "font-liberation-nerd-font" do
  version "3.4.0"
  sha256 "c9c25282d2d4c8eda098fc009e69cd62de35f599927939cb091275a4493eeb55"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}LiberationMono.zip"
  name "Literation Nerd Font families (Liberation Mono)"
  homepage "https:github.comryanoasisnerd-fonts"

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