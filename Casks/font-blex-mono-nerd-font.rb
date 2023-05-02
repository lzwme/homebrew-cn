cask "font-blex-mono-nerd-font" do
  version "3.0.0"
  sha256 "ca104358629dc07868ad0848c2627923dd8f650a623079a27e8175ebb3edd623"

  url "https://ghproxy.com/https://github.com/ryanoasis/nerd-fonts/releases/download/v#{version}/IBMPlexMono.zip"
  name "BlexMono Nerd Font families (IBM Plex Mono)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https://github.com/ryanoasis/nerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "BlexMonoExtLtNerdFont-Italic.ttf"
  font "BlexMonoExtLtNerdFont-Regular.ttf"
  font "BlexMonoExtLtNerdFontMono-Italic.ttf"
  font "BlexMonoExtLtNerdFontMono-Regular.ttf"
  font "BlexMonoExtLtNerdFontPropo-Italic.ttf"
  font "BlexMonoExtLtNerdFontPropo-Regular.ttf"
  font "BlexMonoMedmNerdFont-Italic.ttf"
  font "BlexMonoMedmNerdFont-Regular.ttf"
  font "BlexMonoMedmNerdFontMono-Italic.ttf"
  font "BlexMonoMedmNerdFontMono-Regular.ttf"
  font "BlexMonoMedmNerdFontPropo-Italic.ttf"
  font "BlexMonoMedmNerdFontPropo-Regular.ttf"
  font "BlexMonoNerdFont-Bold.ttf"
  font "BlexMonoNerdFont-BoldItalic.ttf"
  font "BlexMonoNerdFont-Italic.ttf"
  font "BlexMonoNerdFont-Light.ttf"
  font "BlexMonoNerdFont-LightItalic.ttf"
  font "BlexMonoNerdFont-Regular.ttf"
  font "BlexMonoNerdFont-Thin.ttf"
  font "BlexMonoNerdFont-ThinItalic.ttf"
  font "BlexMonoNerdFontMono-Bold.ttf"
  font "BlexMonoNerdFontMono-BoldItalic.ttf"
  font "BlexMonoNerdFontMono-Italic.ttf"
  font "BlexMonoNerdFontMono-Light.ttf"
  font "BlexMonoNerdFontMono-LightItalic.ttf"
  font "BlexMonoNerdFontMono-Regular.ttf"
  font "BlexMonoNerdFontMono-Thin.ttf"
  font "BlexMonoNerdFontMono-ThinItalic.ttf"
  font "BlexMonoNerdFontPropo-Bold.ttf"
  font "BlexMonoNerdFontPropo-BoldItalic.ttf"
  font "BlexMonoNerdFontPropo-Italic.ttf"
  font "BlexMonoNerdFontPropo-Light.ttf"
  font "BlexMonoNerdFontPropo-LightItalic.ttf"
  font "BlexMonoNerdFontPropo-Regular.ttf"
  font "BlexMonoNerdFontPropo-Thin.ttf"
  font "BlexMonoNerdFontPropo-ThinItalic.ttf"
  font "BlexMonoSmBldNerdFont-Italic.ttf"
  font "BlexMonoSmBldNerdFont-Regular.ttf"
  font "BlexMonoSmBldNerdFontMono-Italic.ttf"
  font "BlexMonoSmBldNerdFontMono-Regular.ttf"
  font "BlexMonoSmBldNerdFontPropo-Italic.ttf"
  font "BlexMonoSmBldNerdFontPropo-Regular.ttf"
  font "BlexMonoTextNerdFont-Italic.ttf"
  font "BlexMonoTextNerdFont-Regular.ttf"
  font "BlexMonoTextNerdFontMono-Italic.ttf"
  font "BlexMonoTextNerdFontMono-Regular.ttf"
  font "BlexMonoTextNerdFontPropo-Italic.ttf"
  font "BlexMonoTextNerdFontPropo-Regular.ttf"
end