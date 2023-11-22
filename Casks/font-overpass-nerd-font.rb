cask "font-overpass-nerd-font" do
  version "3.1.0"
  sha256 "52611c9e333df8caa35b480a53cb673b58e3b15d255ac00e97e14e6d61f8c1c5"

  url "https://ghproxy.com/https://github.com/ryanoasis/nerd-fonts/releases/download/v#{version}/Overpass.zip"
  name "Overpass Nerd Font families (Overpass)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https://github.com/ryanoasis/nerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "OverpassMNerdFont-Bold.otf"
  font "OverpassMNerdFont-Light.otf"
  font "OverpassMNerdFont-Regular.otf"
  font "OverpassMNerdFont-SemiBold.otf"
  font "OverpassMNerdFontMono-Bold.otf"
  font "OverpassMNerdFontMono-Light.otf"
  font "OverpassMNerdFontMono-Regular.otf"
  font "OverpassMNerdFontMono-SemiBold.otf"
  font "OverpassMNerdFontPropo-Bold.otf"
  font "OverpassMNerdFontPropo-Light.otf"
  font "OverpassMNerdFontPropo-Regular.otf"
  font "OverpassMNerdFontPropo-SemiBold.otf"
  font "OverpassNerdFont-Bold.otf"
  font "OverpassNerdFont-BoldItalic.otf"
  font "OverpassNerdFont-ExtraBold.otf"
  font "OverpassNerdFont-ExtraBoldItalic.otf"
  font "OverpassNerdFont-ExtraLight.otf"
  font "OverpassNerdFont-ExtraLightItalic.otf"
  font "OverpassNerdFont-Heavy.otf"
  font "OverpassNerdFont-HeavyItalic.otf"
  font "OverpassNerdFont-Italic.otf"
  font "OverpassNerdFont-Light.otf"
  font "OverpassNerdFont-LightItalic.otf"
  font "OverpassNerdFont-Regular.otf"
  font "OverpassNerdFont-SemiBold.otf"
  font "OverpassNerdFont-SemiBoldItalic.otf"
  font "OverpassNerdFont-Thin.otf"
  font "OverpassNerdFont-ThinItalic.otf"
  font "OverpassNerdFontPropo-Bold.otf"
  font "OverpassNerdFontPropo-BoldItalic.otf"
  font "OverpassNerdFontPropo-ExtraBold.otf"
  font "OverpassNerdFontPropo-ExtraBoldItalic.otf"
  font "OverpassNerdFontPropo-ExtraLight.otf"
  font "OverpassNerdFontPropo-ExtraLightItalic.otf"
  font "OverpassNerdFontPropo-Heavy.otf"
  font "OverpassNerdFontPropo-HeavyItalic.otf"
  font "OverpassNerdFontPropo-Italic.otf"
  font "OverpassNerdFontPropo-Light.otf"
  font "OverpassNerdFontPropo-LightItalic.otf"
  font "OverpassNerdFontPropo-Regular.otf"
  font "OverpassNerdFontPropo-SemiBold.otf"
  font "OverpassNerdFontPropo-SemiBoldItalic.otf"
  font "OverpassNerdFontPropo-Thin.otf"
  font "OverpassNerdFontPropo-ThinItalic.otf"

  # No zap stanza required
end