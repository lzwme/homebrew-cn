cask "font-jetbrains-mono-nerd-font" do
  version "3.0.1"
  sha256 "977f16dcb70c45b8ddb5c00ca1276352ff6bfd0e5054c8628ea36f62712ecdf9"

  url "https://ghproxy.com/https://github.com/ryanoasis/nerd-fonts/releases/download/v#{version}/JetBrainsMono.zip"
  name "JetBrainsMono Nerd Font families (JetBrains Mono)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https://github.com/ryanoasis/nerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "JetBrainsMonoNLNerdFont-Bold.ttf"
  font "JetBrainsMonoNLNerdFont-BoldItalic.ttf"
  font "JetBrainsMonoNLNerdFont-ExtraBold.ttf"
  font "JetBrainsMonoNLNerdFont-ExtraBoldItalic.ttf"
  font "JetBrainsMonoNLNerdFont-ExtraLight.ttf"
  font "JetBrainsMonoNLNerdFont-ExtraLightItalic.ttf"
  font "JetBrainsMonoNLNerdFont-Italic.ttf"
  font "JetBrainsMonoNLNerdFont-Light.ttf"
  font "JetBrainsMonoNLNerdFont-LightItalic.ttf"
  font "JetBrainsMonoNLNerdFont-Medium.ttf"
  font "JetBrainsMonoNLNerdFont-MediumItalic.ttf"
  font "JetBrainsMonoNLNerdFont-Regular.ttf"
  font "JetBrainsMonoNLNerdFont-SemiBold.ttf"
  font "JetBrainsMonoNLNerdFont-SemiBoldItalic.ttf"
  font "JetBrainsMonoNLNerdFont-Thin.ttf"
  font "JetBrainsMonoNLNerdFont-ThinItalic.ttf"
  font "JetBrainsMonoNLNerdFontMono-Bold.ttf"
  font "JetBrainsMonoNLNerdFontMono-BoldItalic.ttf"
  font "JetBrainsMonoNLNerdFontMono-ExtraBold.ttf"
  font "JetBrainsMonoNLNerdFontMono-ExtraBoldItalic.ttf"
  font "JetBrainsMonoNLNerdFontMono-ExtraLight.ttf"
  font "JetBrainsMonoNLNerdFontMono-ExtraLightItalic.ttf"
  font "JetBrainsMonoNLNerdFontMono-Italic.ttf"
  font "JetBrainsMonoNLNerdFontMono-Light.ttf"
  font "JetBrainsMonoNLNerdFontMono-LightItalic.ttf"
  font "JetBrainsMonoNLNerdFontMono-Medium.ttf"
  font "JetBrainsMonoNLNerdFontMono-MediumItalic.ttf"
  font "JetBrainsMonoNLNerdFontMono-Regular.ttf"
  font "JetBrainsMonoNLNerdFontMono-SemiBold.ttf"
  font "JetBrainsMonoNLNerdFontMono-SemiBoldItalic.ttf"
  font "JetBrainsMonoNLNerdFontMono-Thin.ttf"
  font "JetBrainsMonoNLNerdFontMono-ThinItalic.ttf"
  font "JetBrainsMonoNLNerdFontPropo-Bold.ttf"
  font "JetBrainsMonoNLNerdFontPropo-BoldItalic.ttf"
  font "JetBrainsMonoNLNerdFontPropo-ExtraBold.ttf"
  font "JetBrainsMonoNLNerdFontPropo-ExtraBoldItalic.ttf"
  font "JetBrainsMonoNLNerdFontPropo-ExtraLight.ttf"
  font "JetBrainsMonoNLNerdFontPropo-ExtraLightItalic.ttf"
  font "JetBrainsMonoNLNerdFontPropo-Italic.ttf"
  font "JetBrainsMonoNLNerdFontPropo-Light.ttf"
  font "JetBrainsMonoNLNerdFontPropo-LightItalic.ttf"
  font "JetBrainsMonoNLNerdFontPropo-Medium.ttf"
  font "JetBrainsMonoNLNerdFontPropo-MediumItalic.ttf"
  font "JetBrainsMonoNLNerdFontPropo-Regular.ttf"
  font "JetBrainsMonoNLNerdFontPropo-SemiBold.ttf"
  font "JetBrainsMonoNLNerdFontPropo-SemiBoldItalic.ttf"
  font "JetBrainsMonoNLNerdFontPropo-Thin.ttf"
  font "JetBrainsMonoNLNerdFontPropo-ThinItalic.ttf"
  font "JetBrainsMonoNerdFont-Bold.ttf"
  font "JetBrainsMonoNerdFont-BoldItalic.ttf"
  font "JetBrainsMonoNerdFont-ExtraBold.ttf"
  font "JetBrainsMonoNerdFont-ExtraBoldItalic.ttf"
  font "JetBrainsMonoNerdFont-ExtraLight.ttf"
  font "JetBrainsMonoNerdFont-ExtraLightItalic.ttf"
  font "JetBrainsMonoNerdFont-Italic.ttf"
  font "JetBrainsMonoNerdFont-Light.ttf"
  font "JetBrainsMonoNerdFont-LightItalic.ttf"
  font "JetBrainsMonoNerdFont-Medium.ttf"
  font "JetBrainsMonoNerdFont-MediumItalic.ttf"
  font "JetBrainsMonoNerdFont-Regular.ttf"
  font "JetBrainsMonoNerdFont-SemiBold.ttf"
  font "JetBrainsMonoNerdFont-SemiBoldItalic.ttf"
  font "JetBrainsMonoNerdFont-Thin.ttf"
  font "JetBrainsMonoNerdFont-ThinItalic.ttf"
  font "JetBrainsMonoNerdFontMono-Bold.ttf"
  font "JetBrainsMonoNerdFontMono-BoldItalic.ttf"
  font "JetBrainsMonoNerdFontMono-ExtraBold.ttf"
  font "JetBrainsMonoNerdFontMono-ExtraBoldItalic.ttf"
  font "JetBrainsMonoNerdFontMono-ExtraLight.ttf"
  font "JetBrainsMonoNerdFontMono-ExtraLightItalic.ttf"
  font "JetBrainsMonoNerdFontMono-Italic.ttf"
  font "JetBrainsMonoNerdFontMono-Light.ttf"
  font "JetBrainsMonoNerdFontMono-LightItalic.ttf"
  font "JetBrainsMonoNerdFontMono-Medium.ttf"
  font "JetBrainsMonoNerdFontMono-MediumItalic.ttf"
  font "JetBrainsMonoNerdFontMono-Regular.ttf"
  font "JetBrainsMonoNerdFontMono-SemiBold.ttf"
  font "JetBrainsMonoNerdFontMono-SemiBoldItalic.ttf"
  font "JetBrainsMonoNerdFontMono-Thin.ttf"
  font "JetBrainsMonoNerdFontMono-ThinItalic.ttf"
  font "JetBrainsMonoNerdFontPropo-Bold.ttf"
  font "JetBrainsMonoNerdFontPropo-BoldItalic.ttf"
  font "JetBrainsMonoNerdFontPropo-ExtraBold.ttf"
  font "JetBrainsMonoNerdFontPropo-ExtraBoldItalic.ttf"
  font "JetBrainsMonoNerdFontPropo-ExtraLight.ttf"
  font "JetBrainsMonoNerdFontPropo-ExtraLightItalic.ttf"
  font "JetBrainsMonoNerdFontPropo-Italic.ttf"
  font "JetBrainsMonoNerdFontPropo-Light.ttf"
  font "JetBrainsMonoNerdFontPropo-LightItalic.ttf"
  font "JetBrainsMonoNerdFontPropo-Medium.ttf"
  font "JetBrainsMonoNerdFontPropo-MediumItalic.ttf"
  font "JetBrainsMonoNerdFontPropo-Regular.ttf"
  font "JetBrainsMonoNerdFontPropo-SemiBold.ttf"
  font "JetBrainsMonoNerdFontPropo-SemiBoldItalic.ttf"
  font "JetBrainsMonoNerdFontPropo-Thin.ttf"
  font "JetBrainsMonoNerdFontPropo-ThinItalic.ttf"

  # No zap stanza required
end