cask "font-overpass-nerd-font" do
  version "3.4.0"
  sha256 "39e5a4c1ce400486ab6c11724a0997de6257231283923079134272ed4beeb843"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}Overpass.zip"
  name "Overpass Nerd Font families (Overpass)"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

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