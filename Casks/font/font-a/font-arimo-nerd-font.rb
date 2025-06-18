cask "font-arimo-nerd-font" do
  version "3.4.0"
  sha256 "ed6f9667a581d3406063110a330a98cf5b9f618031cce606db798944056604c4"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}Arimo.zip"
  name "Arimo Nerd Font (Arimo)"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  font "ArimoNerdFont-Bold.ttf"
  font "ArimoNerdFont-BoldItalic.ttf"
  font "ArimoNerdFont-Italic.ttf"
  font "ArimoNerdFont-Regular.ttf"
  font "ArimoNerdFontPropo-Bold.ttf"
  font "ArimoNerdFontPropo-BoldItalic.ttf"
  font "ArimoNerdFontPropo-Italic.ttf"
  font "ArimoNerdFontPropo-Regular.ttf"

  # No zap stanza required
end