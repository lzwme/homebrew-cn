cask "font-hasklug-nerd-font" do
  version "3.1.1"
  sha256 "a6825db98cc521dab0c18766e28c662c6f1a3ebd36e40e8b191942ad3bd439f9"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}Hasklig.zip"
  name "Hasklug Nerd Font (Hasklig)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "HasklugNerdFont-Black.otf"
  font "HasklugNerdFont-BlackItalic.otf"
  font "HasklugNerdFont-Bold.otf"
  font "HasklugNerdFont-BoldItalic.otf"
  font "HasklugNerdFont-ExtraLight.otf"
  font "HasklugNerdFont-ExtraLightItalic.otf"
  font "HasklugNerdFont-Italic.otf"
  font "HasklugNerdFont-Light.otf"
  font "HasklugNerdFont-LightItalic.otf"
  font "HasklugNerdFont-Medium.otf"
  font "HasklugNerdFont-MediumItalic.otf"
  font "HasklugNerdFont-Regular.otf"
  font "HasklugNerdFont-SemiBold.otf"
  font "HasklugNerdFont-SemiBoldItalic.otf"
  font "HasklugNerdFontMono-Black.otf"
  font "HasklugNerdFontMono-BlackItalic.otf"
  font "HasklugNerdFontMono-Bold.otf"
  font "HasklugNerdFontMono-BoldItalic.otf"
  font "HasklugNerdFontMono-ExtraLight.otf"
  font "HasklugNerdFontMono-ExtraLightItalic.otf"
  font "HasklugNerdFontMono-Italic.otf"
  font "HasklugNerdFontMono-Light.otf"
  font "HasklugNerdFontMono-LightItalic.otf"
  font "HasklugNerdFontMono-Medium.otf"
  font "HasklugNerdFontMono-MediumItalic.otf"
  font "HasklugNerdFontMono-Regular.otf"
  font "HasklugNerdFontMono-SemiBold.otf"
  font "HasklugNerdFontMono-SemiBoldItalic.otf"
  font "HasklugNerdFontPropo-Black.otf"
  font "HasklugNerdFontPropo-BlackItalic.otf"
  font "HasklugNerdFontPropo-Bold.otf"
  font "HasklugNerdFontPropo-BoldItalic.otf"
  font "HasklugNerdFontPropo-ExtraLight.otf"
  font "HasklugNerdFontPropo-ExtraLightItalic.otf"
  font "HasklugNerdFontPropo-Italic.otf"
  font "HasklugNerdFontPropo-Light.otf"
  font "HasklugNerdFontPropo-LightItalic.otf"
  font "HasklugNerdFontPropo-Medium.otf"
  font "HasklugNerdFontPropo-MediumItalic.otf"
  font "HasklugNerdFontPropo-Regular.otf"
  font "HasklugNerdFontPropo-SemiBold.otf"
  font "HasklugNerdFontPropo-SemiBoldItalic.otf"

  # No zap stanza required
end