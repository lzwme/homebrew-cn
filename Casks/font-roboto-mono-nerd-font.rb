cask "font-roboto-mono-nerd-font" do
  version "3.1.1"
  sha256 "e84acfb5838ab8636c77a1a3f319e82f7466ee3911dff42be78d086bc5843988"

  url "https://ghproxy.com/https://github.com/ryanoasis/nerd-fonts/releases/download/v#{version}/RobotoMono.zip"
  name "RobotoMono Nerd Font (Roboto Mono)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https://github.com/ryanoasis/nerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "RobotoMonoNerdFont-Bold.ttf"
  font "RobotoMonoNerdFont-BoldItalic.ttf"
  font "RobotoMonoNerdFont-Italic.ttf"
  font "RobotoMonoNerdFont-Light.ttf"
  font "RobotoMonoNerdFont-LightItalic.ttf"
  font "RobotoMonoNerdFont-Medium.ttf"
  font "RobotoMonoNerdFont-MediumItalic.ttf"
  font "RobotoMonoNerdFont-Regular.ttf"
  font "RobotoMonoNerdFont-SemiBold.ttf"
  font "RobotoMonoNerdFont-SemiBoldItalic.ttf"
  font "RobotoMonoNerdFont-Thin.ttf"
  font "RobotoMonoNerdFont-ThinItalic.ttf"
  font "RobotoMonoNerdFontMono-Bold.ttf"
  font "RobotoMonoNerdFontMono-BoldItalic.ttf"
  font "RobotoMonoNerdFontMono-Italic.ttf"
  font "RobotoMonoNerdFontMono-Light.ttf"
  font "RobotoMonoNerdFontMono-LightItalic.ttf"
  font "RobotoMonoNerdFontMono-Medium.ttf"
  font "RobotoMonoNerdFontMono-MediumItalic.ttf"
  font "RobotoMonoNerdFontMono-Regular.ttf"
  font "RobotoMonoNerdFontMono-SemiBold.ttf"
  font "RobotoMonoNerdFontMono-SemiBoldItalic.ttf"
  font "RobotoMonoNerdFontMono-Thin.ttf"
  font "RobotoMonoNerdFontMono-ThinItalic.ttf"
  font "RobotoMonoNerdFontPropo-Bold.ttf"
  font "RobotoMonoNerdFontPropo-BoldItalic.ttf"
  font "RobotoMonoNerdFontPropo-Italic.ttf"
  font "RobotoMonoNerdFontPropo-Light.ttf"
  font "RobotoMonoNerdFontPropo-LightItalic.ttf"
  font "RobotoMonoNerdFontPropo-Medium.ttf"
  font "RobotoMonoNerdFontPropo-MediumItalic.ttf"
  font "RobotoMonoNerdFontPropo-Regular.ttf"
  font "RobotoMonoNerdFontPropo-SemiBold.ttf"
  font "RobotoMonoNerdFontPropo-SemiBoldItalic.ttf"
  font "RobotoMonoNerdFontPropo-Thin.ttf"
  font "RobotoMonoNerdFontPropo-ThinItalic.ttf"

  # No zap stanza required
end