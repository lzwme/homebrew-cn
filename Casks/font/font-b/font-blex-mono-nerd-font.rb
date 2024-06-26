cask "font-blex-mono-nerd-font" do
  version "3.2.1"
  sha256 "0d6c232bcb6acaf4505fc2fd0588f06a4ecd4ca8e9b0b566ab1b6ed48254461a"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}IBMPlexMono.zip"
  name "BlexMono Nerd Font (IBM Plex Mono)"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "BlexMonoNerdFont-Bold.ttf"
  font "BlexMonoNerdFont-BoldItalic.ttf"
  font "BlexMonoNerdFont-ExtraLight.ttf"
  font "BlexMonoNerdFont-ExtraLightItalic.ttf"
  font "BlexMonoNerdFont-Italic.ttf"
  font "BlexMonoNerdFont-Light.ttf"
  font "BlexMonoNerdFont-LightItalic.ttf"
  font "BlexMonoNerdFont-Medium.ttf"
  font "BlexMonoNerdFont-MediumItalic.ttf"
  font "BlexMonoNerdFont-Regular.ttf"
  font "BlexMonoNerdFont-SemiBold.ttf"
  font "BlexMonoNerdFont-SemiBoldItalic.ttf"
  font "BlexMonoNerdFont-Text.ttf"
  font "BlexMonoNerdFont-TextItalic.ttf"
  font "BlexMonoNerdFont-Thin.ttf"
  font "BlexMonoNerdFont-ThinItalic.ttf"
  font "BlexMonoNerdFontMono-Bold.ttf"
  font "BlexMonoNerdFontMono-BoldItalic.ttf"
  font "BlexMonoNerdFontMono-ExtraLight.ttf"
  font "BlexMonoNerdFontMono-ExtraLightItalic.ttf"
  font "BlexMonoNerdFontMono-Italic.ttf"
  font "BlexMonoNerdFontMono-Light.ttf"
  font "BlexMonoNerdFontMono-LightItalic.ttf"
  font "BlexMonoNerdFontMono-Medium.ttf"
  font "BlexMonoNerdFontMono-MediumItalic.ttf"
  font "BlexMonoNerdFontMono-Regular.ttf"
  font "BlexMonoNerdFontMono-SemiBold.ttf"
  font "BlexMonoNerdFontMono-SemiBoldItalic.ttf"
  font "BlexMonoNerdFontMono-Text.ttf"
  font "BlexMonoNerdFontMono-TextItalic.ttf"
  font "BlexMonoNerdFontMono-Thin.ttf"
  font "BlexMonoNerdFontMono-ThinItalic.ttf"
  font "BlexMonoNerdFontPropo-Bold.ttf"
  font "BlexMonoNerdFontPropo-BoldItalic.ttf"
  font "BlexMonoNerdFontPropo-ExtraLight.ttf"
  font "BlexMonoNerdFontPropo-ExtraLightItalic.ttf"
  font "BlexMonoNerdFontPropo-Italic.ttf"
  font "BlexMonoNerdFontPropo-Light.ttf"
  font "BlexMonoNerdFontPropo-LightItalic.ttf"
  font "BlexMonoNerdFontPropo-Medium.ttf"
  font "BlexMonoNerdFontPropo-MediumItalic.ttf"
  font "BlexMonoNerdFontPropo-Regular.ttf"
  font "BlexMonoNerdFontPropo-SemiBold.ttf"
  font "BlexMonoNerdFontPropo-SemiBoldItalic.ttf"
  font "BlexMonoNerdFontPropo-Text.ttf"
  font "BlexMonoNerdFontPropo-TextItalic.ttf"
  font "BlexMonoNerdFontPropo-Thin.ttf"
  font "BlexMonoNerdFontPropo-ThinItalic.ttf"

  # No zap stanza required
end