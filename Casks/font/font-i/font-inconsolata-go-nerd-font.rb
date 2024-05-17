cask "font-inconsolata-go-nerd-font" do
  version "3.2.1"
  sha256 "ca4e96a27c1716a026ad8de51bbb6f066ed6e6582296e4d046b595a7ea3cb5b3"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}InconsolataGo.zip"
  name "InconsolataGo Nerd Font (InconsolataGo)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "InconsolataGoNerdFont-Bold.ttf"
  font "InconsolataGoNerdFont-Regular.ttf"
  font "InconsolataGoNerdFontMono-Bold.ttf"
  font "InconsolataGoNerdFontMono-Regular.ttf"
  font "InconsolataGoNerdFontPropo-Bold.ttf"
  font "InconsolataGoNerdFontPropo-Regular.ttf"

  # No zap stanza required
end