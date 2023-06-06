cask "font-blex-mono-nerd-font" do
  version "3.0.2"
  sha256 "226eb142fed5a0afe9d58ebbc61602d614385d86c35c52bb9b0fbb52542d27ea"

  url "https://ghproxy.com/https://github.com/ryanoasis/nerd-fonts/releases/download/v#{version}/IBMPlexMono.zip"
  name "BlexMono Nerd Font (IBM Plex Mono)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https://github.com/ryanoasis/nerd-fonts"

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