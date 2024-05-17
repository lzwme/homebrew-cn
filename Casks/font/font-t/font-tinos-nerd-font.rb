cask "font-tinos-nerd-font" do
  version "3.2.1"
  sha256 "15c26edd632ee7794149006fbc32759cdca103ed0504d6fcc9bba0cd92a8b2e4"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}Tinos.zip"
  name "Tinos Nerd Font (Tinos)"
  desc "Developer targeted fonts with a high number of glyphs"
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