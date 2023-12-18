cask "font-ubuntu-mono-nerd-font" do
  version "3.1.1"
  sha256 "af7b9940dfe959712a293add9e90d0ea9d43088d9001682767a30741dc52e9b9"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}UbuntuMono.zip"
  name "UbuntuMono Nerd Font (Ubuntu Mono)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "UbuntuMonoNerdFont-Bold.ttf"
  font "UbuntuMonoNerdFont-BoldItalic.ttf"
  font "UbuntuMonoNerdFont-Italic.ttf"
  font "UbuntuMonoNerdFont-Regular.ttf"
  font "UbuntuMonoNerdFontMono-Bold.ttf"
  font "UbuntuMonoNerdFontMono-BoldItalic.ttf"
  font "UbuntuMonoNerdFontMono-Italic.ttf"
  font "UbuntuMonoNerdFontMono-Regular.ttf"
  font "UbuntuMonoNerdFontPropo-Bold.ttf"
  font "UbuntuMonoNerdFontPropo-BoldItalic.ttf"
  font "UbuntuMonoNerdFontPropo-Italic.ttf"
  font "UbuntuMonoNerdFontPropo-Regular.ttf"

  # No zap stanza required
end