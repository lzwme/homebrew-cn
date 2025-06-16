cask "font-recursive-mono-nerd-font" do
  version "3.4.0"
  sha256 "0bd832ed9de2b5955208494808e69528cfc471cc03eea850ecfbf8e3b1ed702f"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}Recursive.zip"
  name "RecMono Nerd Font families (Recursive Mono)"
  homepage "https:github.comryanoasisnerd-fonts"

  no_autobump! because: :bumped_by_upstream

  livecheck do
    url :url
    strategy :github_latest
  end

  font "RecMonoCasualNerdFont-Bold.ttf"
  font "RecMonoCasualNerdFont-BoldItalic.ttf"
  font "RecMonoCasualNerdFont-Italic.ttf"
  font "RecMonoCasualNerdFont-Regular.ttf"
  font "RecMonoCasualNerdFontMono-Bold.ttf"
  font "RecMonoCasualNerdFontMono-BoldItalic.ttf"
  font "RecMonoCasualNerdFontMono-Italic.ttf"
  font "RecMonoCasualNerdFontMono-Regular.ttf"
  font "RecMonoCasualNerdFontPropo-Bold.ttf"
  font "RecMonoCasualNerdFontPropo-BoldItalic.ttf"
  font "RecMonoCasualNerdFontPropo-Italic.ttf"
  font "RecMonoCasualNerdFontPropo-Regular.ttf"
  font "RecMonoDuotoneNerdFont-Bold.ttf"
  font "RecMonoDuotoneNerdFont-BoldItalic.ttf"
  font "RecMonoDuotoneNerdFont-Italic.ttf"
  font "RecMonoDuotoneNerdFont-Regular.ttf"
  font "RecMonoDuotoneNerdFontMono-Bold.ttf"
  font "RecMonoDuotoneNerdFontMono-BoldItalic.ttf"
  font "RecMonoDuotoneNerdFontMono-Italic.ttf"
  font "RecMonoDuotoneNerdFontMono-Regular.ttf"
  font "RecMonoDuotoneNerdFontPropo-Bold.ttf"
  font "RecMonoDuotoneNerdFontPropo-BoldItalic.ttf"
  font "RecMonoDuotoneNerdFontPropo-Italic.ttf"
  font "RecMonoDuotoneNerdFontPropo-Regular.ttf"
  font "RecMonoLinearNerdFont-Bold.ttf"
  font "RecMonoLinearNerdFont-BoldItalic.ttf"
  font "RecMonoLinearNerdFont-Italic.ttf"
  font "RecMonoLinearNerdFont-Regular.ttf"
  font "RecMonoLinearNerdFontMono-Bold.ttf"
  font "RecMonoLinearNerdFontMono-BoldItalic.ttf"
  font "RecMonoLinearNerdFontMono-Italic.ttf"
  font "RecMonoLinearNerdFontMono-Regular.ttf"
  font "RecMonoLinearNerdFontPropo-Bold.ttf"
  font "RecMonoLinearNerdFontPropo-BoldItalic.ttf"
  font "RecMonoLinearNerdFontPropo-Italic.ttf"
  font "RecMonoLinearNerdFontPropo-Regular.ttf"
  font "RecMonoSmCasualNerdFont-Bold.ttf"
  font "RecMonoSmCasualNerdFont-BoldItalic.ttf"
  font "RecMonoSmCasualNerdFont-Italic.ttf"
  font "RecMonoSmCasualNerdFont-Regular.ttf"
  font "RecMonoSmCasualNerdFontMono-Bold.ttf"
  font "RecMonoSmCasualNerdFontMono-BoldItalic.ttf"
  font "RecMonoSmCasualNerdFontMono-Italic.ttf"
  font "RecMonoSmCasualNerdFontMono-Regular.ttf"
  font "RecMonoSmCasualNerdFontPropo-Bold.ttf"
  font "RecMonoSmCasualNerdFontPropo-BoldItalic.ttf"
  font "RecMonoSmCasualNerdFontPropo-Italic.ttf"
  font "RecMonoSmCasualNerdFontPropo-Regular.ttf"

  # No zap stanza required
end