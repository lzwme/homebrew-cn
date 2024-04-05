cask "font-intone-mono-nerd-font" do
  version "3.2.0"
  sha256 "aa3a2073d59fe309bb3842854317a01abf5f3c6a2f6b5963808c61d613aa34b8"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}IntelOneMono.zip"
  name "IntoneMono Nerd Font (Intel One Mono)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IntoneMonoNerdFont-Bold.ttf"
  font "IntoneMonoNerdFont-BoldItalic.ttf"
  font "IntoneMonoNerdFont-Italic.ttf"
  font "IntoneMonoNerdFont-Light.ttf"
  font "IntoneMonoNerdFont-LightItalic.ttf"
  font "IntoneMonoNerdFont-Medium.ttf"
  font "IntoneMonoNerdFont-MediumItalic.ttf"
  font "IntoneMonoNerdFont-Regular.ttf"
  font "IntoneMonoNerdFontMono-Bold.ttf"
  font "IntoneMonoNerdFontMono-BoldItalic.ttf"
  font "IntoneMonoNerdFontMono-Italic.ttf"
  font "IntoneMonoNerdFontMono-Light.ttf"
  font "IntoneMonoNerdFontMono-LightItalic.ttf"
  font "IntoneMonoNerdFontMono-Medium.ttf"
  font "IntoneMonoNerdFontMono-MediumItalic.ttf"
  font "IntoneMonoNerdFontMono-Regular.ttf"
  font "IntoneMonoNerdFontPropo-Bold.ttf"
  font "IntoneMonoNerdFontPropo-BoldItalic.ttf"
  font "IntoneMonoNerdFontPropo-Italic.ttf"
  font "IntoneMonoNerdFontPropo-Light.ttf"
  font "IntoneMonoNerdFontPropo-LightItalic.ttf"
  font "IntoneMonoNerdFontPropo-Medium.ttf"
  font "IntoneMonoNerdFontPropo-MediumItalic.ttf"
  font "IntoneMonoNerdFontPropo-Regular.ttf"

  # No zap stanza required
end