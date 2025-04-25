cask "font-tinos-nerd-font" do
  version "3.4.0"
  sha256 "15116ed3ab80937763dcffae13dcc6a619e9da981d4cf1dd7398ad59ad70b8e2"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}Tinos.zip"
  name "Tinos Nerd Font (Tinos)"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "TinosNerdFont-Bold.ttf"
  font "TinosNerdFont-BoldItalic.ttf"
  font "TinosNerdFont-Italic.ttf"
  font "TinosNerdFont-Regular.ttf"
  font "TinosNerdFontPropo-Bold.ttf"
  font "TinosNerdFontPropo-BoldItalic.ttf"
  font "TinosNerdFontPropo-Italic.ttf"
  font "TinosNerdFontPropo-Regular.ttf"

  # No zap stanza required
end