cask "font-ubuntu-nerd-font" do
  version "3.4.0"
  sha256 "ad18de7f0ccf503123652c92eb8bcb08b53a54153b467aa46a1c58f04a4d4915"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}Ubuntu.zip"
  name "Ubuntu Nerd Font (Ubuntu)"
  homepage "https:github.comryanoasisnerd-fonts"

  no_autobump! because: :bumped_by_upstream

  livecheck do
    url :url
    strategy :github_latest
  end

  font "UbuntuNerdFont-Bold.ttf"
  font "UbuntuNerdFont-BoldItalic.ttf"
  font "UbuntuNerdFont-Condensed.ttf"
  font "UbuntuNerdFont-Italic.ttf"
  font "UbuntuNerdFont-Light.ttf"
  font "UbuntuNerdFont-LightItalic.ttf"
  font "UbuntuNerdFont-Medium.ttf"
  font "UbuntuNerdFont-MediumItalic.ttf"
  font "UbuntuNerdFont-Regular.ttf"
  font "UbuntuNerdFontPropo-Bold.ttf"
  font "UbuntuNerdFontPropo-BoldItalic.ttf"
  font "UbuntuNerdFontPropo-Condensed.ttf"
  font "UbuntuNerdFontPropo-Italic.ttf"
  font "UbuntuNerdFontPropo-Light.ttf"
  font "UbuntuNerdFontPropo-LightItalic.ttf"
  font "UbuntuNerdFontPropo-Medium.ttf"
  font "UbuntuNerdFontPropo-MediumItalic.ttf"
  font "UbuntuNerdFontPropo-Regular.ttf"

  # No zap stanza required
end